import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';

// Helper class to represent a C function signature
class CFunction {
  final String returnType;
  final String name;
  final List<CParameter> parameters;

  CFunction(this.returnType, this.name, this.parameters);
}

class CParameter {
  final String type;
  final String name;

  CParameter(this.type, this.name);
}

final libMap = [
  ["arm64", "arm64-v8a"],
  ["arm", "armeabi-v7a"],
  ["x86", "x86"],
  ["x86_64", "x86_64"],
];
final scriptPath = File(Platform.script.toFilePath()).parent;
final androidJniLibsPath = join(
  dirname(scriptPath.path),
  "android",
  "app",
  "src",
  "main",
  "jniLibs",
);

void main() async {
  final outputFile = File('lib/nknu_core_ffi.dart');

  final content = await getHeaderFileContent();
  final functions = parseFunctions(content);

  final dartContent = generateDartContent(functions);
  outputFile.writeAsStringSync(dartContent);
  print('Generated ${outputFile.path}');

  for (var l in libMap) {
    print("Downloading lib ${l[0]}");
    downloadLib(l[0], l[1]);
  }
}

Future<String> getHeaderFileContent() async {
  var url = Uri.parse(
    "https://github.com/GDG-on-Campus-NKNU/NKNU-Core/releases/latest/download/android_arm64_nknu_core.h",
  );
  var response = await http.get(url);
  return response.body;
}

Future<void> downloadLib(String fileName, String savePath) async {
  var url = Uri.parse(
    "https://github.com/GDG-on-Campus-NKNU/NKNU-Core/releases/latest/download/android_${fileName}_nknu_core.so",
  );
  var response = await http.get(url);
  var file = File(join(androidJniLibsPath, savePath, "libnknucore.so"));
  await file.parent.create(recursive: true);
  await file.writeAsBytes(response.bodyBytes);
}

List<CFunction> parseFunctions(String content) {
  final functions = <CFunction>[];
  // Regex to match extern function declarations
  // Matches: extern char* Login(char* aspNetSessionId, ...);
  // Captures: ReturnType, Name, Parameters
  final regex = RegExp(r'extern\s+(char\*|void)\s+(\w+)\(([^)]*)\);');
  final matches = regex.allMatches(content);

  for (final match in matches) {
    final returnType = match.group(1)!;
    final name = match.group(2)!;
    final paramsString = match.group(3)!;

    final parameters = <CParameter>[];
    if (paramsString.trim().isNotEmpty && paramsString.trim() != 'void') {
      final paramParts = paramsString.split(',');
      for (final part in paramParts) {
        final trimmed = part.trim();
        if (trimmed.isEmpty) continue;

        // Handle "int rawYear" -> type: "int", name: "rawYear"
        // Handle "char* p" -> type: "char*", name: "p"

        final lastSpaceIndex = trimmed.lastIndexOf(' ');
        if (lastSpaceIndex == -1) {
          // Fallback for cases like "void" or weird formatting
          continue;
        }

        final type = trimmed.substring(0, lastSpaceIndex).trim();
        final rawName = trimmed.substring(lastSpaceIndex + 1).trim();
        // Remove generic pointer asterisk if attached to name (unlikely in this header style but possible)
        final paramName = rawName.replaceAll('*', '');

        parameters.add(CParameter(type, paramName));
      }
    }
    functions.add(CFunction(returnType, name, parameters));
  }
  return functions;
}

String generateDartContent(List<CFunction> functions) {
  final buffer = StringBuffer();

  buffer.writeln(
    '// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_element, unused_field',
  );
  buffer.writeln('import \'dart:ffi\';');
  buffer.writeln('import \'dart:io\';');
  buffer.writeln('import \'package:ffi/ffi.dart\';');
  buffer.writeln('import \'dart:convert\' show utf8, base64, jsonDecode;');
  buffer.writeln();
  buffer.writeln('class NknuCoreFfi {');
  buffer.writeln('  static final DynamicLibrary _lib = _loadLibrary();');
  buffer.writeln();
  buffer.writeln('  static DynamicLibrary _loadLibrary() {');
  buffer.writeln('    if (Platform.isAndroid) {');
  buffer.writeln('      return DynamicLibrary.open(\'libnknucore.so\');');
  buffer.writeln('    }');
  buffer.writeln('    if (Platform.isIOS) {');
  buffer.writeln('      // Assuming statically linked or main bundle');
  buffer.writeln('      return DynamicLibrary.process();');
  buffer.writeln('    }');
  buffer.writeln(
    '    throw UnsupportedError(\'Unknown platform: \${Platform.operatingSystem}\');',
  );
  buffer.writeln('  }');
  buffer.writeln();

  // Find the Free function first as we need it for everything
  final freeFunc = functions.firstWhere(
    (f) => f.name == 'Free',
    orElse: () => CFunction('void', 'Free', [CParameter('char*', 'p')]),
  );

  // We need to look up 'Free' manually to ensure it exists and is typed correctly for our internal use
  buffer.writeln('  // Internal Free function from the library');
  buffer.writeln(
    '  static final _FreePtr = _lib.lookup<NativeFunction<Void Function(Pointer<Char>)>>(\'Free\');',
  );
  buffer.writeln(
    '  static final _Free = _FreePtr.asFunction<void Function(Pointer<Char>)>();',
  );
  buffer.writeln();

  for (final func in functions) {
    if (func.name == 'Free') continue; // Handled specially

    final ffiSignature = _generateFfiSignature(func);
    final dartFfiSignature = _generateDartFfiSignature(func);

    buffer.writeln(
      '  static final _${func.name}Ptr = _lib.lookup<NativeFunction<$ffiSignature>>(\'${func.name}\');',
    );
    buffer.writeln(
      '  static final _${func.name} = _${func.name}Ptr.asFunction<$dartFfiSignature>();',
    );
    buffer.writeln();
  }

  // Generate public wrapper methods
  for (final func in functions) {
    if (func.name == 'Free')
      continue; // Users shouldn't call Free manually, we handle it
    _generateWrapperMethod(buffer, func);
  }

  buffer.writeln('}');
  return buffer.toString();
}

String _generateFfiSignature(CFunction func) {
  final ret = _mapTypeToFfi(func.returnType);
  final params = func.parameters.map((p) => _mapTypeToFfi(p.type)).join(', ');
  return '$ret Function($params)';
}

String _generateDartFfiSignature(CFunction func) {
  final ret = _mapTypeToDartFfi(func.returnType);
  final params = func.parameters
      .map((p) => _mapTypeToDartFfi(p.type))
      .join(', ');
  return '$ret Function($params)';
}

String _mapTypeToFfi(String cType) {
  if (cType == 'char*') return 'Pointer<Char>';
  if (cType == 'int')
    return 'Int'; // C int is usually 32-bit, ffi.Int handles this correctly
  if (cType == 'void') return 'Void';
  return 'Void';
}

String _mapTypeToDartFfi(String cType) {
  if (cType == 'char*') return 'Pointer<Char>';
  if (cType == 'int')
    return 'int'; // Dart int is 64-bit, compatible with C int (32-bit)
  if (cType == 'void') return 'void';
  return 'void';
}

void _generateWrapperMethod(StringBuffer buffer, CFunction func) {
  final apiName = func.name[0].toLowerCase() + func.name.substring(1);

  final dartParams = func.parameters
      .map((p) {
        if (p.type == 'char*') return 'String ${p.name}';
        return 'int ${p.name}';
      })
      .join(', ');

  final returnType =
      func.returnType == 'char*' ? 'Map<String, dynamic>' : 'void';

  buffer.writeln('  static $returnType $apiName($dartParams) {');

  // Allocate C strings for arguments
  for (final p in func.parameters) {
    if (p.type == 'char*') {
      buffer.writeln('    final ${p.name}Ptr = ${p.name}.toNativeUtf8();');
    }
  }

  // Prepare arguments for the call
  final callArgs = func.parameters
      .map((p) {
        if (p.type == 'char*') return '${p.name}Ptr.cast<Char>()';
        return p.name;
      })
      .join(', ');

  buffer.write('    ');
  if (func.returnType == 'char*') {
    buffer.write('final resultPtr = ');
  }
  buffer.writeln('_${func.name}($callArgs);');

  // Free argument strings
  for (final p in func.parameters) {
    if (p.type == 'char*') {
      buffer.writeln('    calloc.free(${p.name}Ptr);');
    }
  }

  // Handle return value
  if (func.returnType == 'char*') {
    buffer.writeln('    final result = resultPtr.cast<Utf8>().toDartString();');
    buffer.writeln('    _Free(resultPtr); // Prevent memory leak');
    buffer.writeln(
      '    return jsonDecode(utf8.decode(base64.decode(result)));',
    );
  }

  buffer.writeln('  }');
  buffer.writeln();
}

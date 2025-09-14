import 'dart:io';

void main() {
  String? llvmPath = Platform.environment["LLVM_PATH"];
  if (llvmPath == null) {
    print('Error: Environment variable "LLVM_PATH" not found.');
    exit(1);
  }
  llvmPath = llvmPath.replaceAll("\\", "/");
  print("llvm path: $llvmPath");

  for (List<String> archList in [
    ["arm64", "aarch64", "Arm64"],
    ["arm", "armv7a", "Arm"],
    ["x86_64", "x86_64", "X8664"],
    ["x86", "i686", "X86"],
  ]) {
    final arch = archList[0];
    final target = archList[1];
    final className = archList[2];

    final config = '''
output: '../lib/ffi/bindings/bindings_$arch.dart'
llvm-path:
  - '$llvmPath'
headers:
  entry-points:
    - './libnknu_$arch.h'
name: "LibNknu${className}Bindings"
description: "Bindings for $arch nknu-core"
compiler-opts:
  - "--target=$target-linux-android"
  - "-I $llvmPath/lib/clang/21/include"
  ''';

    File("./bin/ffigen_${arch}_config.yaml").writeAsStringSync(config);
  }
}

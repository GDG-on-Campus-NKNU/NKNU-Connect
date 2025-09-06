import 'dart:ffi';

class FfiLoader {
  static final Map<String, DynamicLibrary> _cache = {};

  static DynamicLibrary load(String name) {
    if (_cache.containsKey(name)) {
      return _cache[name]!;
    }
    final lib = DynamicLibrary.open(name);
    _cache[name] = lib;
    return lib;
  }
}

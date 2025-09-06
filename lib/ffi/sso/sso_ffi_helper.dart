import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:nknu_connect/models/sso/sso_session.dart';

import 'native_sso_bindings.dart';

class SsoFfiHelper {
  final NativeSsoBindings _bindings;

  SsoFfiHelper(DynamicLibrary lib) : _bindings = NativeSsoBindings(lib);

  String decodeResult(String rawResult) {
    return utf8.decode(base64.decode(rawResult));
  }

  String getSession() {
    final ptr = _bindings.getSession();
    final dartStr = ptr.toDartString();
    calloc.free(ptr);
    return decodeResult(dartStr);
  }

  String login(SsoSession session, String account, String password) {
    final sessionIDPtr = session.sessionID.toNativeUtf8();
    final viewStatePtr = session.viewState.toNativeUtf8();
    final accountPtr = account.toNativeUtf8();
    final passwordPtr = password.toNativeUtf8();
    final resultPtr = _bindings.login(
      sessionIDPtr,
      viewStatePtr,
      accountPtr,
      passwordPtr,
    );
    String dartStr = resultPtr.toDartString();
    calloc.free(sessionIDPtr);
    calloc.free(viewStatePtr);
    calloc.free(accountPtr);
    calloc.free(passwordPtr);
    calloc.free(resultPtr);

    return decodeResult(dartStr);
  }

  String getMailServiceAccount(String sessionID) {
    final sessionIDPtr = sessionID.toNativeUtf8();
    final resultPtr = _bindings.getMailServiceAccount(sessionIDPtr);
    String dartStr = resultPtr.toDartString();
    calloc.free(sessionIDPtr);
    calloc.free(resultPtr);
    return decodeResult(dartStr);
  }
}

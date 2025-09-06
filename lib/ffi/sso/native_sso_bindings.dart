import 'dart:ffi';

import 'package:ffi/ffi.dart';

typedef _GetSessionInfoFunc = Pointer<Utf8> Function();
typedef _GetSessionInfoDart = Pointer<Utf8> Function();
typedef _LoginFunc =
    Pointer<Utf8> Function(
      Pointer<Utf8>,
      Pointer<Utf8>,
      Pointer<Utf8>,
      Pointer<Utf8>,
    );
typedef _LoginDart =
    Pointer<Utf8> Function(
      Pointer<Utf8>,
      Pointer<Utf8>,
      Pointer<Utf8>,
      Pointer<Utf8>,
    );
typedef _GetMailServiceAccountFunc = Pointer<Utf8> Function(Pointer<Utf8>);
typedef _GetMailServiceAccountDart = Pointer<Utf8> Function(Pointer<Utf8>);

class NativeSsoBindings {
  final DynamicLibrary _lib;
  late final _GetSessionInfoDart _getSessionInfo;
  late final _LoginDart _login;
  late final _GetMailServiceAccountDart _getMailServiceAccount;

  NativeSsoBindings(this._lib) {
    _getSessionInfo = _lib
        .lookupFunction<_GetSessionInfoFunc, _GetSessionInfoDart>(
          "GetSessionInfo",
        );
    _login = _lib.lookupFunction<_LoginFunc, _LoginDart>("Login");
    _getMailServiceAccount = _lib
        .lookupFunction<_GetMailServiceAccountFunc, _GetMailServiceAccountDart>(
          "GetMailServiceAccount",
        );
  }

  Pointer<Utf8> getSession() => _getSessionInfo();

  Pointer<Utf8> login(
    Pointer<Utf8> sessionID,
    Pointer<Utf8> viewState,
    Pointer<Utf8> account,
    Pointer<Utf8> password,
  ) => _login(sessionID, viewState, account, password);

  Pointer<Utf8> getMailServiceAccount(Pointer<Utf8> sessionID) =>
      _getMailServiceAccount(sessionID);
}

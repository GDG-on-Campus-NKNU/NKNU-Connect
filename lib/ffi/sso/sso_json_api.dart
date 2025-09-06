import 'dart:convert';

import 'package:nknu_connect/models/sso/sso_session.dart';

import 'sso_ffi_helper.dart';

class SsoJsonApi {
  final SsoFfiHelper _helper;

  SsoJsonApi(this._helper);

  Map<String, dynamic> getSessionJson() {
    final str = _helper.getSession();
    return json.decode(str);
  }

  Map<String, dynamic> login(
    SsoSession session,
    String account,
    String password,
  ) {
    return json.decode(_helper.login(session, account, password));
  }

  Map<String, dynamic> getMailServiceAccount(String sessionID) {
    return json.decode(_helper.getMailServiceAccount(sessionID));
  }
}

import 'package:nknu_connect/ffi/sso/sso_json_api.dart';
import 'package:nknu_connect/models/sso/sso_mail_account.dart';
import 'package:nknu_connect/models/sso/sso_session.dart';

class SsoService {
  final SsoJsonApi _jsonApi;

  SsoService(this._jsonApi);

  SsoSession getSession() {
    final json = _jsonApi.getSessionJson();
    return SsoSession.fromJson(json);
  }

  void login(SsoSession session, String account, String password) {
    final loginResult = _jsonApi.login(session, account, password);
    String error = loginResult["err"];
    if (error != "") {
      throw Exception(error);
    }
  }

  SsoMailServiceAccount getMailServiceAccount(String sessionID) {
    final result = _jsonApi.getMailServiceAccount(sessionID);
    return SsoMailServiceAccount.fromJson(result);
  }
}

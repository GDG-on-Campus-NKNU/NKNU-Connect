import 'package:nknu_connect/features/sso/data/models/login_result_model.dart';
import 'package:nknu_connect/nknu_core_ffi.dart';

LoginResultModel login(
  String sessionId,
  String viewState,
  String account,
  String password,
) {
  var r = NknuCoreFfi.login(sessionId, viewState, account, password);
  return LoginResultModel.fromJson(r);
}

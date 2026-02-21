import 'package:nknu_connect/features/sso/data/models/get_session_result_model.dart';
import 'package:nknu_connect/nknu_core_ffi.dart';

GetSessionResultModel getSession() {
  var r = NknuCoreFfi.getSessionInfo();
  return GetSessionResultModel.fromJson(r);
}

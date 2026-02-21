import '../../nknu_core_ffi.dart';
import 'sso_service.dart';

class SchoolSystemModule {
  final SsoService _ssoService;

  SchoolSystemModule(this._ssoService);

  Future<Map<String, dynamic>> getHistoryScore() async {
    return await _ssoService.execute((sessionId, viewState) {
      return NknuCoreFfi.getHistoryScore(sessionId, viewState);
    });
  }

  Future<Map<String, dynamic>> getMailServiceAccount() async {
    return await _ssoService.execute((sessionId, _) {
      return NknuCoreFfi.getMailServiceAccount(sessionId);
    });
  }
}

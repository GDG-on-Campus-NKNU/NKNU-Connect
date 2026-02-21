import 'dart:async';

import '../../nknu_core_ffi.dart';

class SsoService {
  String? _account;
  String? _password;
  String? _aspNetSessionId;
  String? _viewState;

  bool get isAuthenticated => _aspNetSessionId != null && _viewState != null;

  Future<Map<String, dynamic>> login(String account, String password) async {
    _account = account;
    _password = password;
    return await _performLogin();
  }

  Future<Map<String, dynamic>> _performLogin() async {
    if (_account == null || _password == null) {
      return {'success': false, 'message': 'Account or password not set'};
    }

    // 1. 取得初始 Session Info
    final sessionInfo = NknuCoreFfi.getSessionInfo();
    _aspNetSessionId = sessionInfo['aspNetSessionId'];
    _viewState = sessionInfo['viewState'];

    if (_aspNetSessionId == null || _viewState == null) {
      return {'success': false, 'message': 'Failed to get initial session'};
    }

    // 2. 執行登入
    final loginResult = NknuCoreFfi.login(
      _aspNetSessionId!,
      _viewState!,
      _account!,
      _password!,
    );

    if (loginResult['success'] == true) {
      // 更新 Session (登入後可能會變)
      _aspNetSessionId = loginResult['aspNetSessionId'] ?? _aspNetSessionId;
      _viewState = loginResult['viewState'] ?? _viewState;
    } else {
      _aspNetSessionId = null;
      _viewState = null;
    }

    return loginResult;
  }

  /// 執行功能呼叫，包含自動重新登入與重試機制
  Future<Map<String, dynamic>> execute(
    Map<String, dynamic> Function(String sessionId, String viewState) action,
  ) async {
    int loginRetryCount = 0;
    const int maxLoginRetries = 3;

    while (loginRetryCount < maxLoginRetries) {
      // 確保已有 Session
      if (!isAuthenticated) {
        final loginRes = await _performLogin();
        if (loginRes['success'] != true) {
          loginRetryCount++;
          if (loginRetryCount >= maxLoginRetries) return loginRes;
          continue;
        }
      }

      // 執行目標功能
      final result = action(_aspNetSessionId!, _viewState!);

      // 檢查是否為 Session 失效 (假設失效時會回傳特定錯誤，或 success 為 false 且包含 session 關鍵字)
      // 根據需求：如果 session 失效自動使用帳號密碼重新登入
      if (_isSessionExpired(result)) {
        _aspNetSessionId = null; // 強制觸發重新登入
        loginRetryCount++;
        continue;
      }

      return result;
    }

    return {'success': false, 'message': 'Maximum login retries exceeded'};
  }

  bool _isSessionExpired(Map<String, dynamic> result) {
    // 這裡需要根據 FFI 實際回傳的失效特徵來判斷
    // 通常是 success: false 且 message 包含 "session" 或 "login"
    if (result['success'] == false) {
      final msg = (result['message'] ?? '').toString().toLowerCase();
      return msg.contains('session') ||
          msg.contains('expired') ||
          msg.contains('login');
    }
    return false;
  }
}

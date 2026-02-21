import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nknu_connect/core/storage/secure_storage.dart';

import '../../domain/entities/auth_state.dart';

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final session = await storage.read(key: 'session');

    if (session != null && session.isNotEmpty) {
      final username = await storage.read(key: 'username');
      return AuthState(isAuthenticated: true, username: username);
    }
    return AuthState(isAuthenticated: false);
  }

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 500));

    await SecureStorage().write(key: 'session', value: 'dummy_session_token');
    await SecureStorage().write(key: 'username', value: username);
    await SecureStorage().write(key: 'password', value: password);

    state = AsyncValue.data(
      AuthState(isAuthenticated: true, username: username),
    );
  }
}

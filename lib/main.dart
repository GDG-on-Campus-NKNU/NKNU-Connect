import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nknu_connect/core/theme/app_theme.dart';
import 'package:nknu_connect/features/home/presentation/pages/home_page.dart';

void main() {
  runApp(
    ProviderScope(
      child: DevicePreview(
        enabled: kDebugMode,
        builder: (context) => const MyApp(),
      ),
    ),
  );
}

// 建立 FlutterSecureStorage Provider
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// 定義登入狀態模型
class AuthState {
  final bool isAuthenticated;
  final String? username;

  AuthState({required this.isAuthenticated, this.username});
}

// 建立登入狀態 Notifier
class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final storage = ref.watch(secureStorageProvider);
    final session = await storage.read(key: 'session');

    if (session != null && session.isNotEmpty) {
      final username = await storage.read(key: 'username');
      return AuthState(isAuthenticated: true, username: username);
    }
    return AuthState(isAuthenticated: false);
  }

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    // 模擬登入 API 延遲
    await Future.delayed(const Duration(milliseconds: 500));

    final storage = ref.watch(secureStorageProvider);
    await storage.write(key: 'session', value: 'dummy_session_token');
    await storage.write(key: 'username', value: username);
    await storage.write(key: 'password', value: password);

    state = AsyncValue.data(
      AuthState(isAuthenticated: true, username: username),
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final storage = ref.watch(secureStorageProvider);
    await storage.deleteAll();
    state = AsyncValue.data(AuthState(isAuthenticated: false));
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NKNU Connect',
      theme: AppTheme.light,
      home: const SimpleLoginScreen(),
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
    );
  }
}

// 簡易登入畫面
class SimpleLoginScreen extends ConsumerStatefulWidget {
  const SimpleLoginScreen({super.key});

  @override
  ConsumerState<SimpleLoginScreen> createState() => _SimpleLoginScreenState();
}

class _SimpleLoginScreenState extends ConsumerState<SimpleLoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('簡易登入測試')),
      body: authState.when(
        data: (auth) {
          if (auth.isAuthenticated) {
            return Center(
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.all(32),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '已登入',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text('使用者：${auth.username}'),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              ref.read(authProvider.notifier).logout();
                            },
                            child: const Text('登出'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const HomePage(),
                                ),
                              );
                            },
                            child: const Text('前往首頁'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // 未登入，顯示輸入框
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: '帳號',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: '密碼',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      final username = _usernameController.text;
                      final password = _passwordController.text;
                      if (username.isNotEmpty && password.isNotEmpty) {
                        ref
                            .read(authProvider.notifier)
                            .login(username, password);
                      }
                    },
                    child: const Text('登入'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('發生錯誤: $err')),
      ),
    );
  }
}

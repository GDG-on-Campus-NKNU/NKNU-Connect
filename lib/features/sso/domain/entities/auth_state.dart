class AuthState {
  final String? username;

  AuthState({required this.username});

  bool isLoggedIn() {
    return username != null;
  }
}

import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<UserModel?> getLoggedInUser() {
    return _authService.getLoggedInUser();
  }

  String? handleRegister(String fullName, String username, String password) {
    if (fullName.isEmpty || username.isEmpty || password.isEmpty) {
      return 'Semua kolom wajib diisi!';
    }
    return _authService.registerUser(fullName, username, password);
  }

  Future<String?> handleLogin(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return 'Username dan Password wajib diisi.';
    }
    return _authService.loginUser(username, password);
  }

  Future<void> handleLogout() {
    return _authService.logout();
  }
}

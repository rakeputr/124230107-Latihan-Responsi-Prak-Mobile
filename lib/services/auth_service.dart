import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  final Box<UserModel> _userBox = Hive.box('userBox');
  static const String _sessionKey = 'loggedInUser';

  Future<UserModel?> getLoggedInUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString(_sessionKey);

    if (username != null) {
      return _userBox.get(username);
    }
    return null;
  }

  String? registerUser(String fullName, String username, String password) {
    if (_userBox.containsKey(username)) {
      return 'Username sudah terdaftar.';
    }

    final newUser = UserModel(
      fullName: fullName,
      username: username,
      password: password,
    );
    _userBox.put(username, newUser);
    return null;
  }

  Future<String?> loginUser(String username, String password) async {
    final user = _userBox.get(username);

    if (user != null && user.password == password) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sessionKey, username);
      return null;
    }
    return 'Username atau Password salah.';
  }

  Future<bool> checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey) != null;
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}

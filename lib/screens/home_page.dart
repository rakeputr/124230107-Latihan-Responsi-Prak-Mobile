import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  final AuthController _authController = AuthController();

  HomePage({super.key});

  void _logout(BuildContext context) async {
    await _authController.handleLogout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Anime Teratas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Selamat Datang!\nSementara buat cek session login jalan ap egk',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

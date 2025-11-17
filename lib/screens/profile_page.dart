import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  final AuthController _authController = AuthController();

  ProfilePage({super.key});

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
    const String staticNIM = '124230107';
    const String staticNama = 'Rake Putri Cahyani';
    const String staticPhoto = 'rake.jpg';

    return Scaffold(
      body: FutureBuilder<UserModel?>(
        future: _authController.getLoggedInUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('Gagal memuat data pengguna. Silakan login ulang.'),
            );
          }

          final UserModel user = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(staticPhoto),
                ),
                const SizedBox(height: 20),

                _buildInfoRow('Nama Lengkap', staticNama),
                const Divider(),

                _buildInfoRow('NIM', staticNIM),
                const Divider(),

                _buildInfoRow('Username', user.username),
                const Divider(),

                const SizedBox(height: 40),

                ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout', style: TextStyle(fontSize: 16)),
                  onPressed: () => _logout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

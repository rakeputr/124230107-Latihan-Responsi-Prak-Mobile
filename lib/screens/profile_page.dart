import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController _authController = AuthController();

  String? _profilePhotoPath;
  String? _currentUsername;

  final String staticNIM = '124230107';
  final String staticNama = 'Rake Putri Cahyani';
  final String staticDefaultAsset = 'assets/images/rake.jpg';

  String _getPhotoPathKey(String username) {
    return 'profilePhotoPath_$username';
  }

  // ngambil pic dr SharedPreferences
  Future<void> _loadProfilePhoto(String username) async {
    final prefs = await SharedPreferences.getInstance();

    final path = prefs.getString(_getPhotoPathKey(username));

    if (mounted) {
      setState(() {
        _profilePhotoPath = path;
        _currentUsername = username;
      });
    }
  }

  // ini buat ambil foto terus nyimpen di path
  Future<void> _takePhotoAndSave() async {
    if (_currentUsername == null) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final String path = image.path;
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString(_getPhotoPathKey(_currentUsername!), path);

      if (mounted) {
        setState(() {
          _profilePhotoPath =
              path; // rebuild UI biar fotonya reload sama yg baru di jepret
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto profil berhasil diambil dan disimpan!'),
        ),
      );
    }
  }

  void _logout() async {
    await _authController.handleLogout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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

          if (_currentUsername != user.username) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _loadProfilePhoto(user.username);
            });
          }

          ImageProvider imageProvider;
          if (_profilePhotoPath != null) {
            imageProvider = FileImage(File(_profilePhotoPath!));
          } else {
            imageProvider = AssetImage(staticDefaultAsset);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: imageProvider,
                      backgroundColor: Colors.blueGrey.shade200,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: _takePhotoAndSave,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                  onPressed: _logout,
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

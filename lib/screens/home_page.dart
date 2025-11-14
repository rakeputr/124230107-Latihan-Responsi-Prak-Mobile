import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/anime_controller.dart';
import '../widgets/anime_card.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
    // Panggil Controller untuk memuat data saat halaman dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnimeController>(context, listen: false).fetchAnime();
    });
  }

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
    return Consumer<AnimeController>(
      builder: (context, controller, child) {
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
          body: _buildBody(controller),
        );
      },
    );
  }

  Widget _buildBody(AnimeController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage != null) {
      return Center(
        child: Text('Gagal memuat data: ${controller.errorMessage}'),
      );
    }

    if (controller.animeList.isEmpty) {
      return const Center(child: Text('Tidak ada data anime ditemukan.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: controller.animeList.length,
      itemBuilder: (context, index) {
        return AnimeCard(anime: controller.animeList[index]);
      },
    );
  }
}

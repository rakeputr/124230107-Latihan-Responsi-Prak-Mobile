import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/anime_controller.dart';
import '../widgets/anime_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnimeController>(context, listen: false).fetchAnime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimeController>(
      builder: (context, controller, child) {
        return Scaffold(body: _buildBody(controller));
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

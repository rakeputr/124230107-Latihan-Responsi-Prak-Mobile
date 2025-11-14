import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/anime_model.dart';

class DetailPage extends StatefulWidget {
  final AnimeModel anime;

  const DetailPage({super.key, required this.anime});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isFavorite = false;
  bool _isStatusLoading = true;
  static const String _favoriteKey = 'favoriteAnimeIds';

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_favoriteKey) ?? '[]';
    final List<dynamic> favoriteListJson = json.decode(jsonString);

    if (mounted) {
      setState(() {
        _isFavorite = favoriteListJson.any(
          (item) => item['mal_id'] == widget.anime.malId,
        );
        _isStatusLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_favoriteKey) ?? '[]';
    List<dynamic> favoriteListJson = json.decode(jsonString);

    if (_isFavorite) {
      favoriteListJson.removeWhere(
        (item) => item['mal_id'] == widget.anime.malId,
      );
    } else {
      favoriteListJson.add(widget.anime.toJson());
    }

    await prefs.setString(_favoriteKey, json.encode(favoriteListJson));

    if (mounted) {
      setState(() {
        _isFavorite = !_isFavorite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isFavorite ? 'Ditambahkan ke Favorite!' : 'Dihapus dari Favorite!',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.anime.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          _isStatusLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: _toggleFavorite,
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.anime.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.anime.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Score: ${widget.anime.score}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Sinopsis:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Text(
                    widget.anime.synopsis ?? 'Sinopsis tidak tersedia.',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

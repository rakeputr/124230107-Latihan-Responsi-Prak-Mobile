// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime_model.dart';

class ApiService {
  static const String _baseUrl = 'https://api.jikan.moe/v4/top/anime';

  Future<List<AnimeModel>> fetchTopAnime() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        final List<dynamic> data = jsonResponse['data'];

        return data.map((item) => AnimeModel.fromJson(item)).toList();
      } else {
        throw Exception(
          'Gagal memuat data anime. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat koneksi API: $e');
    }
  }
}

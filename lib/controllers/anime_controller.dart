import 'package:flutter/material.dart';
import '../models/anime_model.dart';
import '../services/api_service.dart';

class AnimeController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<AnimeModel> _animeList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AnimeModel> get animeList => _animeList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAnime() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _animeList = await _apiService.fetchTopAnime();
    } catch (e) {
      _errorMessage = e.toString();
      _animeList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

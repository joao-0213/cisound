import 'package:flutter/material.dart';
import '../models/album.dart';
import '../services/lastfm_service.dart';

class SearchViewModel extends ChangeNotifier {
  final LastFmService _service = LastFmService();

  bool isLoading = false;
  List<Album> albums = [];
  String? errorMessage;

  Future<void> fetchAlbums(String query) async {
    if (query.isEmpty) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      albums = await _service.searchAlbums(query);
    } catch (e) {
      errorMessage = 'Erro ao buscar dados. Verifique a internet.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

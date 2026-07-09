import 'package:flutter/material.dart';
import '../models/album.dart';
import '../services/storage_service.dart';

class FavoritesViewModel extends ChangeNotifier {
  final StorageService _storage = StorageService();

  List<Album> albums = [];
  String? errorMessage;

  void loadFavorites() {
    try {
      albums = _storage.getFavorites();
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Erro ao carregar favoritos do banco local.';
    } finally {
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Album album) async {
    try {
      if (isFavorite(album)) {
        await _storage.deleteFavorite(album.mbid);
      } else {
        await _storage.saveFavorite(album);
      }
      loadFavorites();
    } catch (e) {
      errorMessage = 'Erro ao atualizar o favorito.';
      notifyListeners();
    }
  }

  bool isFavorite(Album album) {
    return albums.any((a) => a.mbid == album.mbid);
  }
}
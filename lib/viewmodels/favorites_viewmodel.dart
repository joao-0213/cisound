import 'package:flutter/material.dart';
import '../models/album.dart';
import '../services/storage_service.dart';

class FavoritesViewModel extends ChangeNotifier {
  final StorageService _storage = StorageService();

  List<Album> albums = [];
  String? errorMessage;

  // Carrega a lista completa de favoritos do usuário atual
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

  // Adiciona ou remove o álbum do banco e atualiza a lista em memória
  Future<void> toggleFavorite(Album album) async {
    try {
      if (isFavorite(album)) {
        await _storage.deleteFavorite(album.mbid);
      } else {
        await _storage.saveFavorite(album);
      }
      // Recarrega a lista para refletir a mudança imediatamente na UI
      loadFavorites();
    } catch (e) {
      errorMessage = 'Erro ao atualizar o favorito.';
      notifyListeners();
    }
  }

  // Verifica se o álbum existe na lista em memória
  bool isFavorite(Album album) {
    return albums.any((a) => a.mbid == album.mbid);
  }
}
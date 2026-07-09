import 'package:flutter/material.dart';
import '../models/album_details.dart';
import '../services/lastfm_service.dart';

class AlbumDetailsViewModel extends ChangeNotifier {
  final LastFmService _service = LastFmService();

  bool isLoading = false;
  AlbumDetails? albumDetails;
  String? errorMessage;

  Future<void> loadAlbumDetails({String? mbid, String? artist, String? albumName}) async {
    if ((mbid == null || mbid.isEmpty) && (artist == null || albumName == null)) {
      errorMessage = 'ID ou informações do álbum não encontradas.';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      albumDetails = await _service.getAlbumDetails(
        mbid: mbid,
        artist: artist,
        album: albumName,
      );
    } catch (e) {
      errorMessage = 'Não foi possível carregar as músicas deste álbum.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    albumDetails = null;
    errorMessage = null;
    notifyListeners();
  }
}

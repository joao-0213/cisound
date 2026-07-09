import 'package:flutter/material.dart';
import '../models/album_details.dart';
import '../services/lastfm_service.dart';

class AlbumDetailsViewModel extends ChangeNotifier {
  final LastFmService _service = LastFmService();

  // Estados que a View vai observar
  bool isLoading = false;
  AlbumDetails? albumDetails; // Pode ser nulo no início, antes da API responder
  String? errorMessage;

  // Método que será chamado quando a tela de detalhes abrir
  Future<void> loadAlbumDetails(String mbid) async {
    // Validação de segurança inicial
    if (mbid.isEmpty) {
      errorMessage = 'ID do álbum não encontrado.';
      notifyListeners();
      return;
    }

    // 1. Prepara o estado para o carregamento
    isLoading = true;
    errorMessage = null;
    notifyListeners(); // Avisa a View para mostrar o CircularProgressIndicator

    try {
      // 2. Tenta buscar os dados na API
      albumDetails = await _service.getAlbumDetails(mbid);
    } catch (e) {
      // 3. Captura o erro (ex: sem internet ou falha na API)
      errorMessage = 'Não foi possível carregar as músicas deste álbum.';
    } finally {
      // 4. Independente de dar certo ou errado, o carregamento terminou
      isLoading = false;
      notifyListeners(); // Avisa a View para desenhar a tela final (dados ou erro)
    }
  }

  // Método auxiliar opcional para limpar o estado ao sair da tela
  void clear() {
    albumDetails = null;
    errorMessage = null;
    notifyListeners();
  }
}
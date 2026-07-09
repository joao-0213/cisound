import 'package:flutter/material.dart';
import '../services/storage_service.dart';


class AuthViewModel extends ChangeNotifier {
  final StorageService _storage = StorageService();

  String? currentUser; // <--- O Estado na Memória RAM

  // Chamado quando o app abre para ver se alguém já estava logado
  void checkLoginStatus() {
    currentUser = _storage.getCurrentUser();
    notifyListeners();
  }

  Future<bool> login(String username) async {
    // 1. Salva no disco (Hive)
    await _storage.saveCurrentUser(username);

    // 2. Abre a caixa de favoritos exclusiva dele
    await _storage.openUserBox(username);

    // 3. Salva na memória RAM do app
    currentUser = username;

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    // 1. Apaga do disco
    await _storage.saveCurrentUser('');

    // 2. Apaga da memória
    currentUser = null;

    notifyListeners();
  }
}
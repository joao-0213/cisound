import 'package:flutter/material.dart';
import '../services/storage_service.dart';


class AuthViewModel extends ChangeNotifier {
  final StorageService _storage = StorageService();

  String? currentUser;

  void checkLoginStatus() {
    currentUser = _storage.getCurrentUser();
    notifyListeners();
  }

  Future<bool> login(String username) async {
    await _storage.saveCurrentUser(username);

    await _storage.openUserBox(username);

    currentUser = username;

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await _storage.saveCurrentUser('');

    currentUser = null;

    notifyListeners();
  }
}
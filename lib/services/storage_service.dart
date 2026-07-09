import 'package:hive/hive.dart';
import '../models/album.dart';

class StorageService {
  final String _sessionBoxName = 'sessionBox';

  Future<void> saveCurrentUser(String username) async {
    var box = Hive.box(_sessionBoxName);
    await box.put('currentUser', username);
  }

  String? getCurrentUser() {
    var box = Hive.box(_sessionBoxName);
    return box.get('currentUser');
  }

  Future<void> openUserBox(String username) async {
    await Hive.openBox<Album>('favorites_$username');
  }

  Future<void> saveFavorite(Album album) async {
    final user = getCurrentUser();
    var box = Hive.box<Album>('favorites_$user');
    await box.put(album.mbid, album);
  }

  Future<void> deleteFavorite(String mbid) async {
    final user = getCurrentUser();
    var box = Hive.box<Album>('favorites_$user');
    await box.delete(mbid);
  }

  List<Album> getFavorites() {
    final user = getCurrentUser();
    if(user == null) return [];
    var box = Hive.box<Album>('favorites_$user');
    return box.values.toList();
  }
}
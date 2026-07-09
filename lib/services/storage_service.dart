import 'package:hive/hive.dart';
import '../models/album.dart';

class StorageService {
  final String _sessionBoxName = 'sessionBox';

  // 1. Salvar quem logou
  Future<void> saveCurrentUser(String username) async {
    var box = Hive.box(_sessionBoxName);
    await box.put('currentUser', username);
  }

  // 2. Descobrir quem está logado
  String? getCurrentUser() {
    var box = Hive.box(_sessionBoxName);
    return box.get('currentUser');
  }

  // 3. O SEGREDO: Abre uma caixa SÓ para esse usuário (ex: favorites_Joao)
  Future<void> openUserBox(String username) async {
    await Hive.openBox<Album>('favorites_$username');
  }

  // 4. Salvar Favorito
  Future<void> saveFavorite(Album album) async {
    final user = getCurrentUser();
    var box = Hive.box<Album>('favorites_$user');
    await box.put(album.mbid, album); // Usa o ID do album como "chave"
  }

  // 5. Deletar Favorito
  Future<void> deleteFavorite(String mbid) async {
    final user = getCurrentUser();
    var box = Hive.box<Album>('favorites_$user');
    await box.delete(mbid);
  }

  // 6. Pegar todos
  List<Album> getFavorites() {
    final user = getCurrentUser();
    if(user == null) return [];
    var box = Hive.box<Album>('favorites_$user');
    return box.values.toList();
  }
}
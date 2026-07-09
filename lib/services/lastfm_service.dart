import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/album.dart';
import '../models/album_details.dart';

class LastFmService {
  final String _apiKey = dotenv.env['API_KEY'] ?? '';
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  // O "Future" significa que o resultado vai chegar no futuro (requisição demora)
  Future<List<Album>> searchAlbums(String query) async {
    final url = Uri.parse('$_baseUrl?method=album.search&album=$query&api_key=$_apiKey&format=json');

    // O "await" manda o app pausar e esperar a internet responder
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonDecoded = json.decode(response.body);
      final list = jsonDecoded['results']['albummatches']['album'] as List;

      // Mapeia o array de JSONs para uma lista de objetos Album
      return list.map((item) => Album.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao buscar álbuns na API');
    }
  }

  Future<AlbumDetails> getAlbumDetails(String mbid) async {
    final url = Uri.parse('$_baseUrl?method=album.getinfo&mbid=$mbid&api_key=$_apiKey&format=json');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonDecoded = json.decode(response.body);
      return AlbumDetails.fromJson(jsonDecoded['album']);
    } else {
      throw Exception('Falha ao buscar detalhes do álbum na API');
    }
  }
}

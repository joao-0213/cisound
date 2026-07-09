import 'package:hive/hive.dart';

part 'album.g.dart';

@HiveType(typeId: 0) // Diz ao Hive que este é o tipo de objeto número 0
class Album {
  @HiveField(0) // Mapeia os campos para o banco de dados
  final String mbid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String artist;

  @HiveField(3)
  final String imageUrl;

  Album({
    required this.mbid,
    required this.name,
    required this.artist,
    required this.imageUrl,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    String image = '';
    // A API do Last.fm manda um array de imagens. Pegamos a posição 2 (tamanho large)
    if (json['image'] != null && json['image'].isNotEmpty) {
      image = json['image'][2]['#text'] ?? '';
    }

    return Album(
      mbid: json['mbid'] ?? DateTime.now().toString(), // Se não tiver ID, gera um genérico
      name: json['name'] ?? 'Desconhecido',
      artist: json['artist'] ?? 'Desconhecido',
      imageUrl: image,
    );
  }
}
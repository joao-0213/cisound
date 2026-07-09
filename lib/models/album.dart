import 'package:hive/hive.dart';

part 'album.g.dart';

@HiveType(typeId: 0)
class Album {
  @HiveField(0)
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

    if (json['image'] != null && json['image'].isNotEmpty) {
      image = json['image'][2]['#text'] ?? '';
    }

    return Album(
      mbid: json['mbid'] ?? DateTime.now().toString(),
      name: json['name'] ?? 'Desconhecido',
      artist: json['artist'] ?? 'Desconhecido',
      imageUrl: image,
    );
  }
}
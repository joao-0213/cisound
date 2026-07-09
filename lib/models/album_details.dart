import 'package:cisound/models/track.dart';

import 'album.dart';

class AlbumDetails {
  final Album album;
  final List<String> tags;
  final List<Track> tracks;

  AlbumDetails({
    required this.album,
    required this.tags,
    required this.tracks,
  });

  factory AlbumDetails.fromJson(Map<String, dynamic> json) {
    // 1. Extrai o álbum base do JSON (a estrutura da API de detalhes é um pouco diferente)
    final albumBase = Album.fromJson(json);

    // 2. Extrai as Tags
    final List<String> tagsList = (json['tags']['tag'] as List)
        .map((t) => t['name'] as String)
        .toList();

    // 3. Extrai as Tracks
    final List<Track> tracksList = (json['tracks']['track'] as List)
        .map((t) => Track.fromJson(t))
        .toList();

    return AlbumDetails(album: albumBase, tags: tagsList, tracks: tracksList);
  }
}
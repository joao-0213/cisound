class Track {
  final String name;
  final int duration;

  Track({
    required this.name,
    required this.duration,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      name: json['name'] ?? 'Desconhecida',
      duration: json['duration'] ?? 0,
    );
  }
}
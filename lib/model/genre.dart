class genre {
  final int id;
  final String name;

  genre({
    required this.id,
    required this.name,
  });

  factory genre.fromJson(Map<String, dynamic> json) {
    return genre(
        id: json['id'],
        name: json['name'],
        );
  }
}
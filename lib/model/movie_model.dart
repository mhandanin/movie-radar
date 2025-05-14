import 'dart:convert';

class Movie {
  final String title;
  final String backDropPath;
  final String overView;
  final String posterPath;

  Movie({
    required this.title,
    required this.backDropPath,
    required this.overView,
    required this.posterPath,
  });

  factory Movie.fromMap(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? 'No Title',
      backDropPath: json['backdrop_path'] ?? '',
      overView: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
    );
  }
}

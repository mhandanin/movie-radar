import 'dart:convert';
import 'package:http/http.dart' as http;


import '../model/movie_model.dart';
import 'constants.dart';

class Api {
  final client = http.Client();

  Future<List<Movie>> getUpcomingMovies() async {
    final response = await client.get(Uri.parse(
      'https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey',
    ));

    Map<String, dynamic> json = jsonDecode(response.body);
    List<dynamic> body = json['results'];

    List<Movie> movies = body.map((dynamic item) => Movie.fromMap(item)).toList();

    return movies;
  }

  Future<List<Movie>> getPopularMovies() async {
    final response = await client.get(Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey',
    ));

    Map<String, dynamic> json = jsonDecode(response.body);
    List<dynamic> body = json['results'];

    List<Movie> movies = body.map((dynamic item) => Movie.fromMap(item)).toList();

    return movies;
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response = await client.get(Uri.parse(
      'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey',
    ));

    Map<String, dynamic> json = jsonDecode(response.body);
    List<dynamic> body = json['results'];

    List<Movie> movies = body.map((dynamic item) => Movie.fromMap(item)).toList();

    return movies;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;


import '../model/movie_model.dart';
import 'constants.dart';

class Api {
  final client = http.Client();

  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = apiKey;

  static Future<dynamic> _get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$endpoint?api_key=$_apiKey&language=en-US'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  static Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    final data = await _get('/movie/upcoming');
    return (data['results'] as List)
        .map((movie) => Movie.fromJson(movie))
        .toList();
  }



  static Future<List<Movie>> getPopularMovies({int page = 1}) async {
    final data = await _get('/movie/popular');
    return (data['results'] as List)
        .map((movie) => Movie.fromJson(movie))
        .toList();
  }

  static Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    final data = await _get('/movie/top_rated');
    return (data['results'] as List)
        .map((movie) => Movie.fromJson(movie))
        .toList();
  }


  static Future<Movie> getMovieDetails(int movieId) async {
    final data = await _get('/movie/$movieId');
    return Movie.fromJson(data);
  }

  static Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final data = await http.get(
      Uri.parse('https://api.themoviedb.org/3/search/movie?api_key=f2afcbd1ecfd68f59c18bd0c190b7729&query=a'),
    );
    var data2=json.decode(data.body);
    print(data2);
    return (data2['results'] as List)
        .map((movie) => Movie.fromJson(movie))
        .toList();
  }

}

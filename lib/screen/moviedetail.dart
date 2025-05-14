import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/constants.dart';
import '../model/movie_model.dart';


class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    print('Movie Title in Detail Screen: ${movie.title}');
    print('Movie Backdrop Path: ${movie.backdropPath}');
    print('Movie Poster Path: ${movie.posterPath}');
    print('Movie Release Date: ${movie.releaseDate}');
    print('Movie Genres: ${movie.genres}');
    print('Movie Production Countries: ${movie.productionCountries}');
    print('Movie Production Companies: ${movie.productionCompanies}');
    print('Movie Overview: ${movie.overview}');
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body:// _isLoading
           _buildMovieDetail(),
    );
  }

  Widget _buildMovieDetail() {
    // if (movie == null) {
    //   return const Center(child: Text('No movie details available'));
    // }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Backdrop/Poster
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              movie.backdropPath != null
                  ? Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('${imageBaseUrl}${movie.backdropPath}'),
                    fit: BoxFit.cover,
                  ),
                ),
              )
                  : Container(
                height: 250,
                width: double.infinity,
                color: Colors.grey[800],
                child: const Center(child: Icon(Icons.movie, size: 50, color: Colors.white)),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Poster
                    movie.posterPath != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        '${imageBaseUrl}${movie.posterPath}',
                        height: 180,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Container(
                      height: 180,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.image_not_supported, size: 40, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    // Title and Rating
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                '${movie.voteAverage.toStringAsFixed(1)}/10',
                                style: const TextStyle(
                                  color: Colors.white,
                                  shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Movie Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Release Date
                _buildDetailRow(
                  label: 'Release Date',
                  value: _formatDate(movie.releaseDate),
                ),

                const SizedBox(height: 12),

                // Genres
                if (movie.genres != null && movie.genres!.isNotEmpty)
                _buildDetailRow(
                  label: 'Genres',
                  value: movie.genres!.map((genre) => genre.name).join(', '),
                ),

                const SizedBox(height: 12),

                // Production Countries
                if (movie.productionCountries != null && movie.productionCountries!.isNotEmpty)
                  _buildDetailRow(
                    label: 'Country',
                    value: movie.productionCountries!.map((country) => country.name).join(', '),
                  ),

                const SizedBox(height: 12),

                // Production Companies
                if (movie.productionCompanies != null && movie.productionCompanies!.isNotEmpty)
                  _buildDetailRow(
                    label: 'Production',
                    value: movie.productionCompanies!.map((company) => company.name).join(', '),
                  ),

                const SizedBox(height: 20),

                // Overview
                const Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.overview,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.day}/${date.month}/${date.year}';
  }
}


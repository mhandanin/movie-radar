import 'package:flutter/material.dart';
import '../Data/DB.dart';
import '../api/api.dart';
import '../api/constants.dart';
import '../model/movie_model.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie; // The basic movie info from the list
  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<Movie> _movieDetailsFuture;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  bool _isInWatchlist = false;

  @override
  void initState() {
    super.initState();
    _movieDetailsFuture = Api.getMovieDetails(widget.movie.id);
    _checkIfInWatchlist();
  }

  Future<void> _checkIfInWatchlist() async {
    _isInWatchlist = await _databaseHelper.isMovieInWatchlist(widget.movie.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<Movie>(
        future: _movieDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading movie details: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final detailedMovie = snapshot.data!;
            return _buildMovieDetail(detailedMovie);
          } else {
            return const Center(child: Text('No movie details found.'));
          }
        },
      ),
    );
  }

  Widget _buildMovieDetail(Movie detailedMovie) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Backdrop/Poster
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              detailedMovie.backdropPath != null
                  ? Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          '${imageBaseUrl}${detailedMovie.backdropPath}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                  : Container(
                    height: 250,
                    width: double.infinity,
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(Icons.movie, size: 50, color: Colors.white),
                    ),
                  ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    detailedMovie.posterPath != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            '${imageBaseUrl}${detailedMovie.posterPath}',
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
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            detailedMovie.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 2),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${detailedMovie.voteAverage.toStringAsFixed(1)}/10',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black,
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              IconButton(
                                onPressed: () {
                                  if (_isInWatchlist) {
                                    _databaseHelper.deleteMovie(widget.movie.id).then((_) {
                                      setState(() {
                                        _isInWatchlist = false;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Movie removed from watchlist.')),
                                      );
                                    });
                                  } else {
                                    _databaseHelper.insertMovie(widget.movie).then((_) {
                                      setState(() {
                                        _isInWatchlist = true;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Movie added to watchlist.')),
                                      );
                                    });
                                  }
                                },
                                icon: Icon(_isInWatchlist ? Icons.bookmark : Icons.bookmark_border, color: Colors.white),
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
                const Text(
                  'Overview',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  detailedMovie.overview,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                _buildDetail(
                  label: 'Release Date',
                  value: _formatDate(detailedMovie.releaseDate),
                ),
                const SizedBox(height: 12),
                if (detailedMovie.genres != null &&
                    detailedMovie.genres!.isNotEmpty)
                  _buildDetail(
                    label: 'Genres',
                    value: detailedMovie.genres!
                        .map((genre) => genre.name)
                        .join(', '),
                  ),
                if (detailedMovie.genres == null ||
                    detailedMovie.genres!.isEmpty)
                  _buildDetail(label: 'Genres', value: '-'),
                const SizedBox(height: 12),
                if (detailedMovie.productionCountries != null &&
                    detailedMovie.productionCountries!.isNotEmpty)
                  _buildDetail(
                    label: 'Country',
                    value: detailedMovie.productionCountries!
                        .map((country) => country.name)
                        .join(', '),
                  ),
                if (detailedMovie.productionCountries == null ||
                    detailedMovie.productionCountries!.isEmpty)
                  _buildDetail(label: 'Country', value: '-'),
                const SizedBox(height: 12),
                if (detailedMovie.productionCompanies != null &&
                    detailedMovie.productionCompanies!.isNotEmpty)
                  _buildDetail(
                    label: 'Production',
                    value: detailedMovie.productionCompanies!
                        .map((company) => company.name)
                        .join(', '),
                  ),
                if (detailedMovie.productionCompanies == null ||
                    detailedMovie.productionCompanies!.isEmpty)
                  _buildDetail(label: 'Production', value: '-'),
                const SizedBox(height: 20),


              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetail({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.day}/${date.month}/${date.year}';
  }
}

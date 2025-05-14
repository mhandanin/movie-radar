import 'package:flutter/material.dart';
import 'package:movie_rada_n/screen/moviedetail.dart';
import '../Data/DB.dart';
import '../api/api.dart';
import '../model/movie_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Movie>> upcomingMovies;
  late Future<List<Movie>> popularMovies;
  late Future<List<Movie>> topRatedMovies;
  int _navigationBarCurrentIndex = 0;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  late Future<List<Movie>> _watchlistMovies;

  @override
  void initState() {
    super.initState();
    upcomingMovies = Api.getUpcomingMovies();
    popularMovies = Api.getPopularMovies();
    topRatedMovies = Api.getTopRatedMovies();
    _watchlistMovies = _databaseHelper.getWatchlistMovies();
  }

  // Reusable widget for displaying movies in a horizontal list
  Widget _buildMovieList(String title, Future<List<Movie>> movieFuture) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: FutureBuilder<List<Movie>>(
            future: movieFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final movies = snapshot.data!;
              return ListView.builder(
                itemCount: movies.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: GestureDetector(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/original/${movie.posterPath}',
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () {
                        print('Tapped movie: ${movies[index].title}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(movie: movies[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget for the Home content (movie lists)
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use the reusable _buildMovieList for Popular, Upcoming, and Top Rated movies
            _buildMovieList('Popular', popularMovies),
            _buildMovieList('Upcoming', upcomingMovies),
            _buildMovieList('Top Rated', topRatedMovies),
          ],
        ),
      ),
    );
  }

  // Widget for the Watchlist content
  Widget _buildWatchlistContent() {
    return FutureBuilder<List<Movie>>(
      future: _watchlistMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final movies = snapshot.data;
        if (movies == null || movies.isEmpty) {
          return const Center(child: Text('Your watchlist is empty.',  style: TextStyle(color: Colors.white, fontSize: 16)));
        }
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              child: ListTile(
                leading: movie.posterPath != null
                    ? Image.network(
                  'https://image.tmdb.org/t/p/w92/${movie.posterPath}', // Use a smaller size
                  width: 50,
                  height: 75,
                  fit: BoxFit.cover,
                )
                    : const SizedBox(width: 50, height: 75, child: Icon(Icons.movie)),
                title: Text(movie.title),
                subtitle: Text('Release Year: ${movie.releaseDate?.year ?? "Unknown"}'), // Display the year.
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _databaseHelper.deleteMovie(movie.id).then((_) {
                      setState(() {
                        // Refresh the list after deletion
                        _watchlistMovies = _databaseHelper.getWatchlistMovies();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Movie removed from watchlist.')),
                      );
                    });
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        fixedColor: Colors.white,
        currentIndex: _navigationBarCurrentIndex,
        onTap: (index) {
          setState(() {
            _navigationBarCurrentIndex = index;
            if (index == 1) {
              _watchlistMovies = _databaseHelper.getWatchlistMovies();
            }
          });

        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: 'Watch List',
          ),
        ],
      ),
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        foregroundColor: Colors.white,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.logo_dev)),
        title: const Text('Show Movie'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
        ],
      ),
      body: _navigationBarCurrentIndex == 0 ? _buildHomeContent() : _buildWatchlistContent(),
    );
  }
}

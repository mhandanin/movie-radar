import 'package:flutter/material.dart';
import 'package:movie_rada_n/screen/moviedetail.dart';
import '../Data/DB.dart';
import '../api/api.dart';
import '../model/movie_model.dart';
import 'search.dart';

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


  late Future<List<Movie>> _searchResults;

  @override
  void initState() {
    super.initState();
    upcomingMovies = Api.getUpcomingMovies();
    popularMovies = Api.getPopularMovies();
    topRatedMovies = Api.getTopRatedMovies();
    _watchlistMovies = _databaseHelper.getWatchlistMovies();
    _searchResults = Future.value([]);
  }

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

  // Home Widget
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMovieList('Popular', popularMovies),
            _buildMovieList('Upcoming', upcomingMovies),
            _buildMovieList('Top Rated', topRatedMovies),
          ],
        ),
      ),
    );
  }

  // Watchlist Widget
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
          return const Center(child: Text('Your watchlist is empty.', style: TextStyle(color: Colors.white, fontSize: 16)));
        }
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 2,
              child: ListTile(
                tileColor: Colors.black,
                leading: movie.posterPath != null
                    ? Image.network(
                  'https://image.tmdb.org/t/p/w92/${movie.posterPath}',
                  width: 50,
                  height: 75,
                  fit: BoxFit.cover,
                )
                    : const SizedBox(width: 50, height: 75, child: Icon(Icons.movie)),
                title: Text(movie.title, style: TextStyle(color: Colors.white),),
                subtitle: Text('Release Year: ${movie.releaseDate?.year ?? "Unknown"}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _databaseHelper.deleteMovie(movie.id).then((_) {
                      setState(() {
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


  Widget _buildSearchContent() {
    return const MovieSearchWidget();
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
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        foregroundColor: Colors.white,
        leading: Image.asset('assets/images/logo.png'),
        title: const Text('Movie Radar'),
        centerTitle: true,
      ),
      body: (() {
        switch (_navigationBarCurrentIndex) {
          case 0:
            return _buildHomeContent();
          case 1:
            return _buildWatchlistContent();
          case 2:
            return _buildSearchContent();
          default:
            return _buildHomeContent();
        }
      })(),
    );
  }
}

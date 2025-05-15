import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../api/api.dart';
import '../model/movie_model.dart';
import 'moviedetail.dart';

class MovieSearchWidget extends StatefulWidget {
  const MovieSearchWidget({super.key});

  @override
  _MovieSearchWidgetState createState() => _MovieSearchWidgetState();
}

class _MovieSearchWidgetState extends State<MovieSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final BehaviorSubject<String> _searchSubject = BehaviorSubject<String>();
  late Future<List<Movie>> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchResults = Future.value([]);
    _searchSubject.stream
        .debounceTime(const Duration(milliseconds: 300))
        .listen(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchSubject.close();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _searchResults = Api.searchMovies(query);
      });
    } else {
      setState(() {
        _searchResults = Future.value([]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            style: TextStyle(
              color: Color(0xFFDB0000), // Custom red color
              fontSize: 18,
            ),
            cursorColor: Colors.white,
            controller: _searchController,
            onChanged: (value) {
              _searchSubject.add(value);
            },
            decoration: const InputDecoration(
              labelText: 'Search Movies',
              hintText: 'Enter movie title...',
              prefixIcon: Icon(Icons.search),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFDB0000)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: _searchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No movies found matching your query'));
                } else {
                  final movies = snapshot.data!;
                  return ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return GestureDetector(
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 2,
                          child: ListTile(
                            tileColor: Colors.black
                            , leading: movie.posterPath != null
                              ? Image.network(
                            'https://image.tmdb.org/t/p/w92/${movie
                                .posterPath}',
                            width: 50,
                            height: 75,
                            fit: BoxFit.cover,
                          )
                              : const SizedBox(
                              width: 50, height: 75, child: Icon(Icons.movie)),
                            title: Text(movie.title,
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text(
                                'Release Year: ${movie.releaseDate?.year ??
                                    "-"}'),
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
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
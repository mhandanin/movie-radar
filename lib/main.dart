import 'package:flutter/material.dart';
import 'package:movie_rada_n/screen/home.dart';
import 'package:movie_rada_n/screen/moviedetail.dart';
import 'package:movie_rada_n/screen/niinternet.dart';
import 'package:movie_rada_n/screen/splashscreen.dart';
import 'package:movie_rada_n/screen/watchList.dart';
import 'package:movie_rada_n/model/movie_model.dart'; // Assuming Movie model is here

void main() {
  runApp(MovieApp());
}

class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/home': (context) => Home(),
        '/watchlist': (context) => WatchList(),
        '/no-internet': (context) => NoInternet(),
      },
      onGenerateRoute: (settings) {

        if (settings.name == '/movie-detail') {
          final Movie movie = settings.arguments as Movie;
          return MaterialPageRoute(
            builder: (context) => MovieDetail(movie: movie),
          );
        }
        return null; // Handle undefined routes
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey[900],  // Adjusted to darker background color
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}

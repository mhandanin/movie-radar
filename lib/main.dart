// lib/main.dart
import 'package:flutter/material.dart';
import 'package:movie_rada_n/screen/home.dart';
import 'package:movie_rada_n/screen/moviedetail.dart';
import 'package:movie_rada_n/screen/niinternet.dart';
import 'package:movie_rada_n/screen/splashscreen.dart';
import 'package:movie_rada_n/screen/watchList.dart';

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
        '/movie-detail': (context) => MovieDetail(),
        '/no-internet': (context) => NoInternet(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

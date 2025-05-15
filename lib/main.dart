import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_rada_n/screen/home.dart';
import 'package:movie_rada_n/screen/moviedetail.dart';
import 'package:movie_rada_n/screen/niinternet.dart';
import 'package:movie_rada_n/screen/splashscreen.dart';
import 'package:movie_rada_n/screen/watchList.dart';
import 'package:movie_rada_n/model/movie_model.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  runApp(MovieApp());
}

class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Radar',
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/home': (context) => Home(),
      },
      onGenerateRoute: (settings) {

        if (settings.name == '/movie-detail') {
          final Movie movie = settings.arguments as Movie;
          return MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movie:movie),
          );
        }
        return null;
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black) ,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey[900],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: SplashScreen(),
    );
  }
}

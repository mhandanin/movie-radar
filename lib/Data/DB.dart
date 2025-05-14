import 'package:flutter/material.dart';
import 'package:movie_rada_n/screen/moviedetail.dart';
import '../api/api.dart';
import '../model/movie_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "MovieDatabase.db";
  static const _databaseVersion = 1;
  static const _tableName = "Watchlist";

  // Singleton instance to ensure only one database connection is used
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  // Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Create the database table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        posterPath TEXT NOT NULL,
        releaseYear INTEGER NOT NULL
      )
    ''');
  }

  // Insert a movie into the watchlist
  Future<int> insertMovie(Movie movie) async {
    final db = await database;
    // Ensure releaseDate is not null before accessing its properties.
    int releaseYear = movie.releaseDate?.year ?? 0; // Use 0 as a default value if null.

    return await db.insert(
      _tableName,
      {
        'id': movie.id,
        'title': movie.title,
        'posterPath': movie.posterPath,
        'releaseYear': releaseYear,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Handle duplicates
    );
  }

  // Get all movies from the watchlist
  Future<List<Movie>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Movie( // Use the named constructor.
        id: maps[i]['id'],
        title: maps[i]['title'],
        posterPath: maps[i]['posterPath'],
        releaseDate: DateTime(maps[i]['releaseYear']), // Convert year back to DateTime
        overview: '', // Provide a default value, as it's required by the Movie class.
        voteAverage: 0.0,  // Provide a default value.
      );
    });
  }

  // Delete a movie from the watchlist
  Future<int> deleteMovie(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Check if a movie is in the watchlist
  Future<bool> isMovieInWatchlist(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }
}

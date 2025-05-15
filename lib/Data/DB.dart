import 'dart:io';
import '../model/movie_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';


class DatabaseHelper {
  static const _databaseName = "MovieDatabase.db";
  static const _databaseVersion = 1;
  static const _tableName = "Watchlist";

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  // init db
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Open db
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // create db
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

  // Insert movie
  Future<int> insertMovie(Movie movie) async {
    final db = await database;
    int releaseYear = movie.releaseDate?.year ?? 0;

    return await db.insert(
      _tableName,
      {
        'id': movie.id,
        'title': movie.title,
        'posterPath': movie.posterPath,
        'releaseYear': releaseYear,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get movies
  Future<List<Movie>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Movie(
        id: maps[i]['id'],
        title: maps[i]['title'],
        posterPath: maps[i]['posterPath'],
        releaseDate: DateTime(maps[i]['releaseYear']),
        overview: '',
        voteAverage: 0.0,
      );
    });
  }

  // Delete  movie
  Future<int> deleteMovie(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Check if its in the watchlist
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

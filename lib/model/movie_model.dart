// import 'dart:convert';
//
// class Movie {
//   final String title;
//   final String backDropPath;
//   final String overView;
//   final String posterPath;
//
//   Movie({
//     required this.title,
//     required this.backDropPath,
//     required this.overView,
//     required this.posterPath,
//   });
//
//   factory Movie.fromMap(Map<String, dynamic> json) {
//     return Movie(
//       title: json['title'] ?? 'No Title',
//       backDropPath: json['backdrop_path'] ?? '',
//       overView: json['overview'] ?? '',
//       posterPath: json['poster_path'] ?? '',
//     );
//   }
// }

import 'dart:convert';



class Movie {
  final int id;
  final String title;
  final String overview;
  final DateTime? releaseDate;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int? voteCount;
  final int? runtime;
  final String? tagline;
  final List<int>? genreIds;
  final List<Genre>? genres;
  final List<ProductionCountry>? productionCountries;
  final List<ProductionCompany>? productionCompanies;
  final List<SpokenLanguage>? spokenLanguages;
  final String? status;
  final int? budget;
  final int? revenue;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.releaseDate,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    this.voteCount,
    this.runtime,
    this.tagline,
    this.genreIds,
    this.genres,
    this.productionCountries,
    this.productionCompanies,
    this.spokenLanguages,
    this.status,
    this.budget,
    this.revenue,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      releaseDate: json['release_date'] != null && json['release_date'] != ""
          ? DateTime.tryParse(json['release_date'])
          : null,
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'],
      runtime: json['runtime'],
      tagline: json['tagline'],
      genreIds: json['genre_ids'] != null
          ? List<int>.from(json['genre_ids'])
          : null,
      genres: json['genres'] != null
          ? (json['genres'] as List)
          .map((g) => Genre.fromJson(g))
          .toList()
          : null,
      productionCountries: json['production_countries'] != null
          ? (json['production_countries'] as List)
          .map((c) => ProductionCountry.fromJson(c))
          .toList()
          : null,
      productionCompanies: json['production_companies'] != null
          ? (json['production_companies'] as List)
          .map((c) => ProductionCompany.fromJson(c))
          .toList()
          : null,
      spokenLanguages: json['spoken_languages'] != null
          ? (json['spoken_languages'] as List)
          .map((s) => SpokenLanguage.fromJson(s))
          .toList()
          : null,
      status: json['status'],
      budget: json['budget'],
      revenue: json['revenue'],
    );
  }
}


class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(id: json['id'], name: json['name']);
  }
}

class ProductionCountry {
  final String iso;
  final String name;

  ProductionCountry({required this.iso, required this.name});

  factory ProductionCountry.fromJson(Map<String, dynamic> json) {
    return ProductionCountry(iso: json['iso_3166_1'], name: json['name']);
  }
}

class ProductionCompany {
  final int id;
  final String name;
  final String? logoPath;
  final String? originCountry;

  ProductionCompany({
    required this.id,
    required this.name,
    this.logoPath,
    this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) {
    return ProductionCompany(
      id: json['id'],
      name: json['name'],
      logoPath: json['logo_path'],
      originCountry: json['origin_country'],
    );
  }
}

class SpokenLanguage {
  final String iso;
  final String name;
  final String? englishName;

  SpokenLanguage({
    required this.iso,
    required this.name,
    this.englishName,
  });

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) {
    return SpokenLanguage(
      iso: json['iso_639_1'],
      name: json['name'],
      englishName: json['english_name'],
    );
  }
}

class MovieCredits {
  final List<Cast> cast;
  final List<Crew> crew;

  MovieCredits({
    required this.cast,
    required this.crew,
  });

  factory MovieCredits.fromJson(Map<String, dynamic> json) {
    return MovieCredits(
      cast: (json['cast'] as List).map((cast) => Cast.fromJson(cast)).toList(),
      crew: (json['crew'] as List).map((crew) => Crew.fromJson(crew)).toList(),
    );
  }
}

class Cast {
  final int id;
  final String name;
  final String? profilePath;
  final String character;

  Cast({
    required this.id,
    required this.name,
    this.profilePath,
    required this.character,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'],
      character: json['character'] ?? '',
    );
  }
}

class Crew {
  final int id;
  final String name;
  final String? profilePath;
  final String job;
  final String department;

  Crew({
    required this.id,
    required this.name,
    this.profilePath,
    required this.job,
    required this.department,
  });

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'],
      job: json['job'] ?? '',
      department: json['department'] ?? '',
    );
  }
}

class Video {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;

  Video({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      key: json['key'],
      name: json['name'],
      site: json['site'],
      type: json['type'],
    );
  }
}

class MovieResponse {
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  MovieResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      page: json['page'],
      results: (json['results'] as List).map((movie) => Movie.fromJson(movie)).toList(),
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }
}

// ============================================================
// models/movie.dart  –  Data model for Movie and Trailer
// ============================================================

class Trailer {
  final String id;
  final String name;
  final String type; // e.g. "Trailer", "Teaser", "Clip"

  const Trailer({
    required this.id,
    required this.name,
    required this.type,
  });
}

class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating; // 0.0 – 10.0
  final List<Trailer> trailers;

  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
  });
}

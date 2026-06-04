import '../models/movie.dart';

final List<Movie> sampleMovies = [
  Movie(
    id: 1,
    title: 'Dune: Part Two',
    posterUrl:
        'https://image.tmdb.org/t/p/w500/8b8R8l88Qje9dn9OE8PY05Nxl1X.jpg',
    overview:
        'Paul Atreides unites with Chani and the Fremen while seeking revenge '
        'against the conspirators who destroyed his family.',
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    rating: 8.6,
    trailers: [
      Trailer(id: 't1', name: 'Official Trailer #1', type: 'Trailer'),
      Trailer(id: 't2', name: 'IMAX Sneak Peek', type: 'Teaser'),
    ],
  ),
  Movie(
    id: 2,
    title: 'Deadpool & Wolverine',
    posterUrl:
        'https://image.tmdb.org/t/p/w500/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg',
    overview:
        'The multiverse gets messy when Wade Wilson teams up with Wolverine '
        'for a not-so-family-friendly mission.',
    genres: ['Action', 'Comedy'],
    rating: 8.3,
    trailers: [
      Trailer(id: 't3', name: 'Red Band Trailer', type: 'Trailer'),
      Trailer(id: 't4', name: 'Behind the Scenes', type: 'Clip'),
    ],
  ),
];

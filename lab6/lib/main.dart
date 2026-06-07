import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

// ─────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────
class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

// ─────────────────────────────────────────────
// Sample Data
// ─────────────────────────────────────────────
const List<Movie> allMovies = [
  Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Action', 'Sci-Fi'],
    posterUrl: 'https://picsum.photos/seed/inception/200/300',
    rating: 8.8,
  ),
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Drama'],
    posterUrl: 'https://picsum.photos/seed/darkknight/200/300',
    rating: 9.0,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Sci-Fi', 'Drama'],
    posterUrl: 'https://picsum.photos/seed/interstellar/200/300',
    rating: 8.6,
  ),
  Movie(
    title: 'The Hangover',
    year: 2009,
    genres: ['Comedy'],
    posterUrl: 'https://picsum.photos/seed/hangover/200/300',
    rating: 7.7,
  ),
  Movie(
    title: 'Avengers: Endgame',
    year: 2019,
    genres: ['Action', 'Sci-Fi'],
    posterUrl: 'https://picsum.photos/seed/endgame/200/300',
    rating: 8.4,
  ),
  Movie(
    title: 'Forrest Gump',
    year: 1994,
    genres: ['Drama', 'Comedy'],
    posterUrl: 'https://picsum.photos/seed/forrestgump/200/300',
    rating: 8.8,
  ),
];

// ─────────────────────────────────────────────
// App Root
// ─────────────────────────────────────────────
class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GenreScreen(),
    );
  }
}

// ─────────────────────────────────────────────
// Genre Screen (Stateful)
// ─────────────────────────────────────────────
class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  // Search
  String searchQuery = '';

  // Genre chips
  final List<String> genres = [
    'Action',
    'Drama',
    'Comedy',
    'Sci-Fi',
    'Horror',
    'Romance',
  ];
  final Set<String> selectedGenres = {};

  // Sort
  String selectedSort = 'A–Z';
  final List<String> sortOptions = ['A–Z', 'Z–A', 'Year', 'Rating'];

  // ── Filtering & Sorting ──────────────────────
  List<Movie> get visibleMovies {
    List<Movie> result = allMovies.where((movie) {
      // Search filter
      final matchesSearch =
          movie.title.toLowerCase().contains(searchQuery.toLowerCase());

      // Genre filter
      final matchesGenre = selectedGenres.isEmpty ||
          movie.genres.any((g) => selectedGenres.contains(g));

      return matchesSearch && matchesGenre;
    }).toList();

    // Sort
    switch (selectedSort) {
      case 'A–Z':
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Z–A':
        result.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'Year':
        result.sort((a, b) => b.year.compareTo(a.year));
        break;
      case 'Rating':
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return result;
  }

  // ── Helpers ──────────────────────────────────
  void _toggleGenre(String genre) {
    setState(() {
      if (selectedGenres.contains(genre)) {
        selectedGenres.remove(genre);
      } else {
        selectedGenres.add(genre);
      }
    });
  }

  void _clearFilters() {
    setState(() {
      searchQuery = '';
      selectedGenres.clear();
      selectedSort = 'A–Z';
    });
  }

  // ── Build ────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title ──
              _buildTitle(),
              const SizedBox(height: 16),

              // ── Search Bar ──
              _buildSearchBar(),
              const SizedBox(height: 14),

              // ── Genre Chips ──
              _buildGenreChips(),
              const SizedBox(height: 10),

              // ── Sort Bar ──
              _buildSortBar(),
              const SizedBox(height: 12),

              // ── Movie List (responsive) ──
              Expanded(child: _buildMovieList()),
            ],
          ),
        ),
      ),
    );
  }

  // ── Section Builders ─────────────────────────

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Find a Movie',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
          ),
        ),
        if (selectedGenres.isNotEmpty || searchQuery.isNotEmpty)
          TextButton.icon(
            onPressed: _clearFilters,
            icon: const Icon(Icons.clear, size: 16),
            label: const Text('Clear filters'),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
          ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search movies...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
        onChanged: (value) => setState(() => searchQuery = value),
      ),
    );
  }

  Widget _buildGenreChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Genres',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            if (selectedGenres.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${selectedGenres.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        // Wrap tự động xuống dòng – responsive
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: genres.map((genre) {
            final isSelected = selectedGenres.contains(genre);
            return GestureDetector(
              onTap: () => _toggleGenre(genre),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      isSelected ? Colors.deepPurple : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.deepPurple
                        : Colors.grey.shade300,
                  ),
                  boxShadow: [
                    if (!isSelected)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                      ),
                  ],
                ),
                child: Text(
                  genre,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSortBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${visibleMovies.length} movie${visibleMovies.length != 1 ? 's' : ''} found',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        Row(
          children: [
            const Text('Sort: ',
                style: TextStyle(fontWeight: FontWeight.w500)),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSort,
                  isDense: true,
                  items: sortOptions
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s,
                                style: const TextStyle(fontSize: 13)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => selectedSort = value);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMovieList() {
    final movies = visibleMovies;

    if (movies.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_filter, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text('No movies found',
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }

    // LayoutBuilder để quyết định layout theo chiều rộng
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 800;

        if (isWide) {
          // Tablet / Web: 2 cột GridView
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3.2,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) =>
                _buildMovieCard(movies[index], isWide: true),
          );
        } else {
          // Phone: single column ListView
          return ListView.separated(
            itemCount: movies.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) =>
                _buildMovieCard(movies[index], isWide: false),
          );
        }
      },
    );
  }

  Widget _buildMovieCard(Movie movie, {required bool isWide}) {
    final posterWidth = isWide ? 70.0 : 80.0;
    final posterHeight = isWide ? 95.0 : 110.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Poster
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            ),
            child: Image.network(
              movie.posterUrl,
              width: posterWidth,
              height: posterHeight,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: posterWidth,
                height: posterHeight,
                color: Colors.grey.shade200,
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF1A1A2E),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${movie.year}',
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  // Genre tags
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: movie.genres
                        .map((g) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                g,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.deepPurple.shade700,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),

          // Rating
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded,
                    color: Colors.amber, size: 18),
                Text(
                  movie.rating.toStringAsFixed(1),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
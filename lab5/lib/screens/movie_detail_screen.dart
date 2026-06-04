import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero banner
            Stack(
              children: [
                Image.network(
                  movie.posterUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.movie, size: 80),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Genres
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 8,
                children: movie.genres
                    .map((g) => Chip(label: Text(g)))
                    .toList(),
              ),
            ),

            const SizedBox(height: 8),

            // Overview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(movie.overview),
            ),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : null,
                      ),
                      onPressed: () =>
                          setState(() => _isFavorite = !_isFavorite),
                    ),
                    const Text('Favorite'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.star_border),
                      onPressed: () {},
                    ),
                    const Text('Rate'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {},
                    ),
                    const Text('Share'),
                  ],
                ),
              ],
            ),

            const Divider(),

            // Trailers
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
              child: Text('Trailers',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: movie.trailers.length,
              itemBuilder: (_, i) => ListTile(
                leading: const Icon(Icons.play_circle_outline),
                title: Text(movie.trailers[i].name),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

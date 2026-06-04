import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../models/movie.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movies')),
      body: ListView.builder(
        itemCount: sampleMovies.length,
        itemBuilder: (context, index) {
          final movie = sampleMovies[index];
          return ListTile(
            leading: Image.network(
              movie.posterUrl,
              width: 56,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.movie, size: 56),
            ),
            title: Text(movie.title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
                '☆ ${movie.rating} • ${movie.genres.join(', ')}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetailScreen(movie: movie),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

final List<Map<String, String>> movies = [
  {'title': 'Avatar',      'description': 'Sample description'},
  {'title': 'Inception',   'description': 'Sample description'},
  {'title': 'Interstellar','description': 'Sample description'},
  {'title': 'Joker',       'description': 'Sample description'},
  {'title': 'Dune',        'description': 'Sample description'},
  {'title': 'The Matrix',  'description': 'Sample description'},
];

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 3 – Layout Demo')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Now Playing',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Text(
                      movie['title']![0],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(movie['title']!),
                  subtitle: Text(movie['description']!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
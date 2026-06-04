import 'package:flutter/material.dart';

class CoreWidgetsScreen extends StatelessWidget {
  const CoreWidgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 1 – Core Widgets Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text widget
            const Text(
              'Welcome to Flutter UI',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Icon widget
            const Center(
              child: Icon(Icons.movie, size: 80),
            ),
            const SizedBox(height: 16),

            // Image.network widget
            Image.network(
              'https://picsum.photos/400/200',
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 80),
            ),
            const SizedBox(height: 16),

            // Card + ListTile widget
            Card(
              child: ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Movie Item'),
                subtitle: const Text('This is a sample ListTile inside a Card.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
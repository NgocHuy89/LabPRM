// ============================================================
// main.dart  –  App entry point
// ============================================================

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const MovieApp());

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.deepPurpleAccent,
          secondary: Colors.amber,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      // Named route for the home screen
      // (Detail screen is pushed via Navigator.push + MaterialPageRoute)
      home: const HomeScreen(),
    );
  }
}

import 'package:flutter/material.dart';

class DebugFixScreen extends StatelessWidget {
  const DebugFixScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 5 – Common UI Fixes')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Correct ListView inside Column using Expanded',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          // Fix: ListView inside Column dùng Expanded
          Expanded(
            child: ListView(
              children: const [
                ListTile(leading: Icon(Icons.movie), title: Text('Movie A')),
                ListTile(leading: Icon(Icons.movie), title: Text('Movie B')),
                ListTile(leading: Icon(Icons.movie), title: Text('Movie C')),
                ListTile(leading: Icon(Icons.movie), title: Text('Movie D')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
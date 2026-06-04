import 'package:flutter/material.dart';
import 'exercise1/core_widgets_demo.dart';
import 'exercise2/input_controls_demo.dart';
import 'exercise3/layout_basics_demo.dart';
import 'exercise4/scaffold_theme_demo.dart';
import 'exercise5/debug_fix_demo.dart';

void main() {
  runApp(const Lab4App());
}

class Lab4App extends StatelessWidget {
  const Lab4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4 – Flutter UI Fundamentals',
      theme: ThemeData(useMaterial3: true),
      home: const Lab4MenuScreen(),
    );
  }
}

class Lab4MenuScreen extends StatelessWidget {
  const Lab4MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exercises = [
      {'title': 'Exercise 1 – Core Widgets Demo',    'subtitle': ''},
      {'title': 'Exercise 2 – Input Controls Demo',  'subtitle': ''},
      {'title': 'Exercise 3 – Layout Demo',          'subtitle': ''},
      {'title': 'Exercise 4 – App Structure & Theme','subtitle': ''},
      {'title': 'Exercise 5 – Common UI Fixes',      'subtitle': ''},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Lab 4 – Flutter UI Fundamentals')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(exercises[index]['title']!),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Widget screen;
                switch (index) {
                  case 0: screen = const CoreWidgetsScreen(); break;
                  case 1: screen = const InputControlsDemo(); break;
                  case 2: screen = const LayoutScreen(); break;
                  case 3: screen = const ThemeApp(); break;
                  case 4: screen = const DebugFixScreen(); break;
                  default: return;
                }
                Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
              },
            ),
          );
        },
      ),
    );
  }
}
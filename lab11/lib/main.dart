import 'package:flutter/material.dart';
import 'repositories/task_repository.dart';
import 'screens/task_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TaskRepository repository = TaskRepository();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TaskListScreen(repository: repository),
    );
  }
}

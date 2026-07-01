import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final TaskRepository repository;
  const TaskDetailScreen({super.key, required this.task, required this.repository});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.title);
  }

  void _saveTask() {
    final updatedTask = Task(
      id: widget.task.id,
      title: _controller.text.trim(),
      isCompleted: widget.task.isCompleted,
    );
    widget.repository.updateTask(updatedTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              key: const Key('detailTitleField'),
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}

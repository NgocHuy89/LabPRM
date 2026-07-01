import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  final TaskRepository repository;
  const TaskListScreen({super.key, required this.repository});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _controller = TextEditingController();

  void _addTask() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      widget.repository.addTask(Task(
        id: DateTime.now().toString(),
        title: _controller.text.trim(),
      ));
      _controller.clear();
    });
  }

  void _navigateToDetail(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
          task: task,
          repository: widget.repository,
        ),
      ),
    );
    setState(() {}); // Refresh list
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.repository.tasks;
    return Scaffold(
      appBar: AppBar(title: const Text('Taskly')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Enter task...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTask,
                )
              ],
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text('No tasks yet. Add one!'))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return ListTile(
                        title: Text(task.title),
                        trailing: Checkbox(
                          value: task.isCompleted,
                          onChanged: (_) {
                            setState(() {
                              task.toggle();
                              widget.repository.updateTask(task);
                            });
                          },
                        ),
                        onTap: () => _navigateToDetail(task),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

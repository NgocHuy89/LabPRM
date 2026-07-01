import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _controller = TextEditingController();
  
  // Exercise 12.2: Image caching
  late Image _logoImage;

  @override
  void initState() {
    super.initState();
    _logoImage = Image.asset('assets/images/logo.png', width: 40, height: 40);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache the image to avoid layout jumping and improve performance
    precacheImage(_logoImage.image, context);
  }

  void _addTask() {
    if (_controller.text.trim().isEmpty) return;
    context.read<TaskProvider>().addTask(Task(
      id: DateTime.now().toString(),
      title: _controller.text.trim(),
    ));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            _logoImage,
            const SizedBox(width: 8),
            const Text('Taskly Optimized'),
          ],
        ),
      ),
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
            child: Selector<TaskProvider, List<Task>>(
              selector: (context, provider) => provider.tasks,
              builder: (context, tasks, child) {
                if (tasks.isEmpty) {
                  return const Center(child: Text('No tasks yet. Add one!'));
                }
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskTile(
                      key: ValueKey(task.id),
                      task: task,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

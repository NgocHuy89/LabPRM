import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/repositories/task_repository.dart';

void main() {
  group('Task Repository Unit Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    test('addTask() adds a task to the list', () {
      // Arrange
      final task = Task(id: '1', title: 'Test Task');

      // Act
      repository.addTask(task);

      // Assert
      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.title, 'Test Task');
    });

    test('updateTask() updates an existing task', () {
      // Arrange
      final task = Task(id: '1', title: 'Old Title');
      repository.addTask(task);
      final updatedTask = Task(id: '1', title: 'New Title', isCompleted: true);

      // Act
      repository.updateTask(updatedTask);

      // Assert
      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.title, 'New Title');
      expect(repository.tasks.first.isCompleted, true);
    });

    test('deleteTask() removes a task by id', () {
      // Arrange
      final task1 = Task(id: '1', title: 'Task 1');
      final task2 = Task(id: '2', title: 'Task 2');
      repository.addTask(task1);
      repository.addTask(task2);

      // Act
      repository.deleteTask('1');

      // Assert
      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.id, '2');
    });
  });
}

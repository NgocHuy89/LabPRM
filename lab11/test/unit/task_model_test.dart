import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';

void main() {
  group('Task Model Unit Tests', () {
    test('Task should have default completed value of false', () {
      // Arrange
      final task = Task(id: '1', title: 'Buy groceries');

      // Act & Assert
      expect(task.isCompleted, false);
    });

    test('toggle() switches isCompleted from false to true', () {
      // Arrange
      final task = Task(id: '1', title: 'Buy groceries');

      // Act
      task.toggle();

      // Assert
      expect(task.isCompleted, true);
    });

    test('toggle() switches isCompleted from true to false', () {
      // Arrange
      final task = Task(id: '1', title: 'Buy groceries', isCompleted: true);

      // Act
      task.toggle();

      // Assert
      expect(task.isCompleted, false);
    });
  });
}

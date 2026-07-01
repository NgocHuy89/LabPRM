import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  Widget createWidgetUnderTest(TaskRepository repository) {
    return MaterialApp(
      home: TaskListScreen(repository: repository),
    );
  }

  group('TaskList Widget Tests', () {
    testWidgets('Displays Empty State when no tasks exist', (WidgetTester tester) async {
      // Arrange
      final repository = TaskRepository();

      // Act
      await tester.pumpWidget(createWidgetUnderTest(repository));

      // Assert
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    testWidgets('Adds a task and verifies UI updates', (WidgetTester tester) async {
      // Arrange
      final repository = TaskRepository();
      await tester.pumpWidget(createWidgetUnderTest(repository));

      // Act
      await tester.enterText(find.byType(TextField), 'New Task');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump(); // Rebuild UI

      // Assert
      expect(find.text('No tasks yet. Add one!'), findsNothing);
      expect(find.text('New Task'), findsOneWidget);
    });

    testWidgets('Displays multiple tasks correctly', (WidgetTester tester) async {
      // Arrange
      final repository = TaskRepository();
      await tester.pumpWidget(createWidgetUnderTest(repository));

      // Act
      await tester.enterText(find.byType(TextField), 'Task 1');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      
      await tester.enterText(find.byType(TextField), 'Task 2');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Assert
      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsOneWidget);
    });
  });
}

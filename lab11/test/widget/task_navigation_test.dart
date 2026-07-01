import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  testWidgets('Navigates from TaskList to TaskDetail when tapping a task', (WidgetTester tester) async {
    // Arrange
    final repository = TaskRepository();
    repository.addTask(Task(id: '1', title: 'Seeded Task'));

    await tester.pumpWidget(MaterialApp(
      home: TaskListScreen(repository: repository),
    ));

    // Assert initial state
    expect(find.text('Seeded Task'), findsOneWidget);

    // Act
    await tester.tap(find.text('Seeded Task'));
    await tester.pumpAndSettle(); // Wait for navigation animation

    // Assert navigation result
    expect(find.text('Task Detail'), findsOneWidget); // AppBar title
    expect(find.byKey(const Key('detailTitleField')), findsOneWidget);
  });
}

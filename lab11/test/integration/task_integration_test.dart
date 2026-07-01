import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/main.dart'; // import MyApp

void main() {
  testWidgets('Integration Test: Full Task Flow', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(MyApp());

    // Act 1: Add "Original title"
    await tester.enterText(find.byType(TextField), 'Original title');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Assert 1
    expect(find.text('Original title'), findsOneWidget);

    // Act 2: Tap task -> open detail
    await tester.tap(find.text('Original title'));
    await tester.pumpAndSettle();

    // Assert 2
    expect(find.text('Task Detail'), findsOneWidget);

    // Act 3: Edit -> "Updated title"
    final detailField = find.byKey(const Key('detailTitleField'));
    expect(detailField, findsOneWidget);
    await tester.enterText(detailField, 'Updated title');
    
    // Save
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle(); // wait for pop animation

    // Assert 3: Verify updated title appears in list
    expect(find.text('Updated title'), findsOneWidget);
    expect(find.text('Original title'), findsNothing);
  });
}

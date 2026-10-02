import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:accessibility_widget/accessibility_widget.dart';

void main() {
  testWidgets('AccessibilityWidget smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AccessibilityWidget(
          child: Scaffold(
            body: Text('Accessibility Demo App'),
            floatingActionButton: AccessibilityFloatingActionButton(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Accessibility Demo App'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('AccessibilityFloatingActionButton opens preferences sheet', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AccessibilityWidget(
          child: Scaffold(
            body: Text('Screen 1'),
            floatingActionButton: AccessibilityFloatingActionButton(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Screen 1'), findsOneWidget);
    expect(find.byType(AccessibilityFloatingActionButton), findsOneWidget);

    // Tap the FAB
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Accessibility'), findsOneWidget);
  });
}

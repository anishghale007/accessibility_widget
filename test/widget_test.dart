import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AccessibilityDemoApp smoke test', (WidgetTester tester) async {
    // await tester.pumpWidget(const AccessibilityDemoApp());
    await tester.pumpAndSettle();

    expect(find.text('Accessibility Widget Demo'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}

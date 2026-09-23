import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:accessibility_widget/accessibility_widget.dart';

void main() {
  group('AccessibleHeading', () {
    testWidgets('unconditionally exposes Semantics(header: true)', (WidgetTester tester) async {
      final AccessibilityController controller = AccessibilityController(
        store: InMemoryAccessibilityStore(),
      );

      await tester.pumpWidget(
        AccessibilityScope(
          controller: controller,
          child: const MaterialApp(
            home: Scaffold(
              body: AccessibleHeading(
                level: 1,
                child: Text('Main Title'),
              ),
            ),
          ),
        ),
      );

      // Verify header semantic flag is active even when highlightHeadings is off
      final Semantics semanticsWidget = tester.widget<Semantics>(
        find.ancestor(
          of: find.text('Main Title'),
          matching: find.byType(Semantics),
        ).first,
      );

      expect(semanticsWidget.properties.header, isTrue);
    });

    testWidgets('adds visual accent decoration when highlightHeadings is enabled', (WidgetTester tester) async {
      final AccessibilityController controller = AccessibilityController(
        store: InMemoryAccessibilityStore(),
      );

      await tester.pumpWidget(
        AccessibilityScope(
          controller: controller,
          child: const MaterialApp(
            home: Scaffold(
              body: AccessibleHeading(
                level: 1,
                child: Text('Main Title'),
              ),
            ),
          ),
        ),
      );

      controller.toggleHighlightHeadings();
      await tester.pumpAndSettle();

      expect(find.byType(Row), findsWidgets);
      expect(find.text('Main Title'), findsOneWidget);
    });
  });
}

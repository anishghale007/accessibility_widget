import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:accessibility_widget/accessibility_widget.dart';

void main() {
  group('AccessibleLink', () {
    testWidgets('renders child unmodified when highlightLinks is false and fires tap', (WidgetTester tester) async {
      final AccessibilityController controller = AccessibilityController(
        store: InMemoryAccessibilityStore(),
      );
      bool wasTapped = false;

      await tester.pumpWidget(
        AccessibilityScope(
          controller: controller,
          child: MaterialApp(
            home: Scaffold(
              body: AccessibleLink(
                onTap: () => wasTapped = true,
                child: const Text('Clickable Link'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Clickable Link'), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new), findsNothing);

      await tester.tap(find.text('Clickable Link'));
      expect(wasTapped, isTrue);
    });

    testWidgets('renders link icon and underline styling when highlightLinks is true', (WidgetTester tester) async {
      final AccessibilityController controller = AccessibilityController(
        store: InMemoryAccessibilityStore(),
      );

      await tester.pumpWidget(
        AccessibilityScope(
          controller: controller,
          child: const MaterialApp(
            home: Scaffold(
              body: AccessibleLink(
                child: Text('Clickable Link'),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.open_in_new), findsNothing);

      controller.toggleHighlightLinks();
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.open_in_new), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:accessibility_widget/accessibility_widget.dart';

void main() {
  group('AccessibleTile', () {
    testWidgets('renders unmodified child when highlightTiles is false and handles tap', (WidgetTester tester) async {
      final AccessibilityController controller = AccessibilityController(
        store: InMemoryAccessibilityStore(),
      );
      bool wasTapped = false;

      await tester.pumpWidget(
        AccessibilityScope(
          controller: controller,
          child: MaterialApp(
            home: Scaffold(
              body: AccessibleTile(
                onTap: () => wasTapped = true,
                child: const ListTile(
                  title: Text('Account Settings'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Account Settings'), findsOneWidget);
      await tester.tap(find.text('Account Settings'));
      expect(wasTapped, isTrue);
    });

    testWidgets('adds decorated boundary border when highlightTiles is true', (WidgetTester tester) async {
      final AccessibilityController controller = AccessibilityController(
        store: InMemoryAccessibilityStore(),
      );

      await tester.pumpWidget(
        AccessibilityScope(
          controller: controller,
          child: const MaterialApp(
            home: Scaffold(
              body: AccessibleTile(
                child: Text('Profile Tile'),
              ),
            ),
          ),
        ),
      );

      controller.toggleHighlightTiles();
      await tester.pumpAndSettle();

      final Finder decoratedBoxFinder = find.byType(DecoratedBox);
      expect(decoratedBoxFinder, findsWidgets);

      final DecoratedBox decoratedBox = tester.widget<DecoratedBox>(decoratedBoxFinder.first);
      final BoxDecoration decoration = decoratedBox.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });
  });
}

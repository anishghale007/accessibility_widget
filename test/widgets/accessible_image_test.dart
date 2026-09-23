import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:accessibility_widget/accessibility_widget.dart';

void main() {
  group('AccessibleImage', () {
    testWidgets('renders child image normally when hideImages is false', (WidgetTester tester) async {
      final AccessibilityController controller = AccessibilityController(
        store: InMemoryAccessibilityStore(),
      );

      await tester.pumpWidget(
        AccessibilityScope(
          controller: controller,
          child: const MaterialApp(
            home: Scaffold(
              body: AccessibleImage(
                child: Text('Rendered Image Content'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Rendered Image Content'), findsOneWidget);
      expect(find.byIcon(Icons.image_not_supported_outlined), findsNothing);
    });

    testWidgets('swaps to placeholder with semantics when hideImages is true', (WidgetTester tester) async {
      final AccessibilityController controller = AccessibilityController(
        store: InMemoryAccessibilityStore(),
      );

      await tester.pumpWidget(
        AccessibilityScope(
          controller: controller,
          child: const MaterialApp(
            home: Scaffold(
              body: AccessibleImage(
                child: Text('Original Image'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Original Image'), findsOneWidget);

      controller.toggleHideImages();
      await tester.pumpAndSettle();

      expect(find.text('Original Image'), findsNothing);
      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
      expect(find.bySemanticsLabel('Image hidden'), findsOneWidget);
    });
  });
}

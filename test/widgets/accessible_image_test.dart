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

    testWidgets('hides image completely when hideImages is true and no placeholder is provided', (WidgetTester tester) async {
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
      expect(find.text('Image hidden'), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('renders custom placeholder with semantics when provided', (WidgetTester tester) async {
      final AccessibilityController controller = AccessibilityController(
        store: InMemoryAccessibilityStore(),
      );

      await tester.pumpWidget(
        AccessibilityScope(
          controller: controller,
          child: const MaterialApp(
            home: Scaffold(
              body: AccessibleImage(
                placeholder: Text('Custom Placeholder'),
                semanticLabel: 'Custom Alt Text',
                child: Text('Original Image'),
              ),
            ),
          ),
        ),
      );

      controller.toggleHideImages();
      await tester.pumpAndSettle();

      expect(find.text('Original Image'), findsNothing);
      expect(find.text('Custom Placeholder'), findsOneWidget);

      final Semantics semanticsWidget = tester.widget<Semantics>(
        find.ancestor(
          of: find.text('Custom Placeholder'),
          matching: find.byType(Semantics),
        ).first,
      );
      expect(semanticsWidget.properties.label, 'Custom Alt Text');
    });
  });
}

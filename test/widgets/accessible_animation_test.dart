import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:accessibility_widget/accessibility_widget.dart';

void main() {
  group('AccessibleAnimation', () {
    testWidgets('renders child when animations are enabled and fallback when disabled', (WidgetTester tester) async {
      final AccessibilityController controller = AccessibilityController(
        store: InMemoryAccessibilityStore(),
      );

      await tester.pumpWidget(
        AccessibilityScope(
          controller: controller,
          child: const MaterialApp(
            home: Scaffold(
              body: AccessibleAnimation(
                fallback: Text('Static Fallback'),
                child: Text('Animated Active'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Animated Active'), findsOneWidget);
      expect(find.text('Static Fallback'), findsNothing);

      // Disable animations
      controller.toggleReduceMotion();
      await tester.pumpAndSettle();

      expect(find.text('Animated Active'), findsNothing);
      expect(find.text('Static Fallback'), findsOneWidget);
    });

    testWidgets('supports AccessibleAnimation.builder pattern', (WidgetTester tester) async {
      final AccessibilityController controller = AccessibilityController(
        store: InMemoryAccessibilityStore(),
      );

      await tester.pumpWidget(
        AccessibilityScope(
          controller: controller,
          child: MaterialApp(
            home: Scaffold(
              body: AccessibleAnimation.builder(
                builder: (context, bool isAnimating, child) {
                  return Text(isAnimating ? 'Running' : 'Stopped');
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Running'), findsOneWidget);

      controller.toggleReduceMotion();
      await tester.pumpAndSettle();

      expect(find.text('Stopped'), findsOneWidget);
    });
  });
}

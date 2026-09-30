import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:accessibility_widget/accessibility_widget.dart';

void main() {
  group('AccessibilityBottomSheet', () {
    testWidgets('dynamically updates theme when toggling dark mode', (WidgetTester tester) async {
      final AccessibilityController controller = AccessibilityController(
        store: InMemoryAccessibilityStore(),
      );

      await tester.pumpWidget(
        AccessibilityScope(
          controller: controller,
          child: MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () => AccessibilityBottomSheet.show(context),
                    child: const Text('Open Settings'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Open bottom sheet
      await tester.tap(find.text('Open Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Accessibility'), findsOneWidget);
      expect(AccessibilityBottomSheet.isOpen, isTrue);

      // Verify initial theme in bottom sheet is light
      Theme themeBefore = tester.widget<Theme>(find.byType(Theme).last);
      expect(themeBefore.data.brightness, Brightness.light);

      // Scroll until 'Dark' is visible, then tap
      await tester.ensureVisible(find.text('Dark'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      expect(controller.settings.darkMode, isTrue);

      // Verify theme inside bottom sheet dynamically updated to dark
      Theme themeAfter = tester.widget<Theme>(find.byType(Theme).last);
      expect(themeAfter.data.brightness, Brightness.dark);

      // Close bottom sheet
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();

      expect(AccessibilityBottomSheet.isOpen, isFalse);
    });
  });
}

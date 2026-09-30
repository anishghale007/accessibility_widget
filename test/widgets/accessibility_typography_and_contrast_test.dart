import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:accessibility_widget/accessibility_widget.dart';

void main() {
  group('AccessibilityWidget Typography & Contrast', () {
    testWidgets('applies dyslexia font, line spacing, and letter spacing across theme', (WidgetTester tester) async {
      final AccessibilityController controller = AccessibilityController(
        store: InMemoryAccessibilityStore(),
      );

      controller.toggleDyslexiaFont();
      controller.setLineSpacing(1.8);
      controller.setLetterSpacing(2.0);
      controller.toggleBoldText();

      late ThemeData observedTheme;

      await tester.pumpWidget(
        MaterialApp(
          home: AccessibilityWidget(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                observedTheme = Theme.of(context);
                return Scaffold(
                  body: Text(
                    'Sample Typography Text',
                    style: observedTheme.textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final TextStyle? bodyStyle = observedTheme.textTheme.bodyMedium;
      expect(bodyStyle, isNotNull);
      expect(bodyStyle!.fontFamily, contains('Andika'));
      expect(bodyStyle.fontWeight, FontWeight.bold);
      expect(bodyStyle.letterSpacing, greaterThanOrEqualTo(2.0));
      expect(bodyStyle.height, isNotNull);
    });

    testWidgets('applies high contrast ColorScheme and card styling', (WidgetTester tester) async {
      final AccessibilityController controller = AccessibilityController(
        store: InMemoryAccessibilityStore(),
      );

      controller.toggleHighContrast();

      late ThemeData observedTheme;
      late MediaQueryData observedMedia;

      await tester.pumpWidget(
        MaterialApp(
          home: AccessibilityWidget(
            controller: controller,
            child: Builder(
              builder: (BuildContext context) {
                observedTheme = Theme.of(context);
                observedMedia = MediaQuery.of(context);
                return const Scaffold(
                  body: Card(
                    child: Text('High Contrast Card'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(observedMedia.highContrast, isTrue);
      expect(observedTheme.colorScheme.onSurface, equals(Colors.black));
      expect(observedTheme.cardTheme.shape, isA<RoundedRectangleBorder>());
    });

    testWidgets('renders slider tiles in panel content with clear SliderTheme', (WidgetTester tester) async {
      final AccessibilityController controller = AccessibilityController(
        store: InMemoryAccessibilityStore(),
      );

      await tester.pumpWidget(
        AccessibilityScope(
          controller: controller,
          child: const MaterialApp(
            home: Scaffold(
              body: AccessibilityPanelContent(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Ensure Slider widgets and SliderThemes are present and rendered
      expect(find.byType(Slider), findsWidgets);
      expect(find.byType(SliderTheme), findsWidgets);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:accessibility_widget/accessibility_widget.dart';

void main() {
  group('AccessibilitySettingsPage', () {
    testWidgets('renders controls and live syncs with controller', (WidgetTester tester) async {
      final AccessibilityController controller = AccessibilityController(
        store: InMemoryAccessibilityStore(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: AccessibilitySettingsPage(
            controller: controller,
          ),
        ),
      );

      expect(find.text('Accessibility'), findsOneWidget);
      expect(find.text('Profiles'), findsOneWidget);
      expect(find.text('Seizure Safe'), findsOneWidget);
      expect(find.text('Vision Impaired'), findsOneWidget);
      expect(find.text('Text & Typography'), findsOneWidget);
      expect(find.byIcon(Icons.restore), findsWidgets);

      // Apply vision impaired profile
      await tester.tap(find.text('Vision Impaired'));
      await tester.pumpAndSettle();

      expect(controller.settings.activeProfile, AccessibilityProfile.visionImpaired);
      expect(controller.settings.textScale, 1.5);

      // Tap reset button in AppBar
      await tester.tap(find.byTooltip('Reset to defaults'));
      await tester.pumpAndSettle();

      expect(controller.settings, AccessibilitySettings.defaults);
      expect(controller.settings.activeProfile, isNull);
    });
  });
}

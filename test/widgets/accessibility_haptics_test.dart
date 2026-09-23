import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:accessibility_widget/accessibility_widget.dart';

void main() {
  group('AccessibilityHaptics', () {
    testWidgets('maybeVibrate executes safely without crashing', (WidgetTester tester) async {
      final AccessibilityController controller = AccessibilityController(
        store: InMemoryAccessibilityStore(),
      );
      controller.toggleHapticFeedback();

      await tester.pumpWidget(
        AccessibilityScope(
          controller: controller,
          child: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () => AccessibilityHaptics.maybeVibrate(context),
                child: const Text('Vibrate Button'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Vibrate Button'));
      await tester.pumpAndSettle();
      expect(controller.settings.hapticFeedback, isTrue);
    });

    test('triggerFeedback runs safely on web without exception', () {
      PlatformInfo.debugIsWebOverride = true;
      addTearDown(() => PlatformInfo.debugIsWebOverride = null);

      expect(() => AccessibilityHaptics.triggerFeedback(), returnsNormally);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:accessibility_widget/accessibility_widget.dart';

void main() {
  group('AccessibilityController', () {
    late InMemoryAccessibilityStore store;
    late AccessibilityController controller;

    setUp(() {
      store = InMemoryAccessibilityStore();
      controller = AccessibilityController(store: store);
    });

    test('initial settings are defaults', () {
      expect(controller.settings, AccessibilitySettings.defaults);
    });

    test('applyProfile updates settings bundle atomically and records activeProfile', () {
      controller.applyProfile(AccessibilityProfile.seizureSafe);
      expect(controller.settings.activeProfile, AccessibilityProfile.seizureSafe);
      expect(controller.settings.stopAnimations, isTrue);
      expect(controller.settings.saturation, 0.5);

      controller.applyProfile(AccessibilityProfile.visionImpaired);
      expect(controller.settings.activeProfile, AccessibilityProfile.visionImpaired);
      expect(controller.settings.textScale, 1.5);
      expect(controller.settings.highContrast, isTrue);
      expect(controller.settings.boldText, isTrue);
      expect(controller.settings.highlightLinks, isTrue);
      expect(controller.settings.highlightTiles, isTrue);
      expect(controller.settings.highlightHeadings, isTrue);
      expect(controller.settings.bigCursor, isTrue);
    });

    test('manual setting change clears activeProfile', () {
      controller.applyProfile(AccessibilityProfile.visionImpaired);
      expect(controller.settings.activeProfile, AccessibilityProfile.visionImpaired);

      controller.setTextScale(1.2);
      expect(controller.settings.activeProfile, isNull);
      expect(controller.settings.textScale, 1.2);
      // Other values remain from profile
      expect(controller.settings.highContrast, isTrue);
    });

    test('reset clears all settings and activeProfile', () {
      controller.applyProfile(AccessibilityProfile.visionImpaired);
      controller.reset();
      expect(controller.settings, AccessibilitySettings.defaults);
      expect(controller.settings.activeProfile, isNull);
    });

    test('restore loads persisted settings from store', () async {
      const AccessibilitySettings persisted = AccessibilitySettings(
        textScale: 1.8,
        boldText: true,
      );
      await store.write(persisted);

      await controller.restore();
      expect(controller.settings.textScale, 1.8);
      expect(controller.settings.boldText, isTrue);
    });
  });
}

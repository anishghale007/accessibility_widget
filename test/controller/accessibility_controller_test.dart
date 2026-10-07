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

    test(
        'toggleProfile allows multi-selecting multiple profiles simultaneously',
        () {
      controller.toggleProfile(AccessibilityProfile.seizureSafe);
      expect(
        controller.settings.isProfileActive(AccessibilityProfile.seizureSafe),
        isTrue,
      );
      expect(controller.settings.stopAnimations, isTrue);
      expect(controller.settings.saturation, 0.5);

      // Add ADHD profile simultaneously
      controller.toggleProfile(AccessibilityProfile.adhd);
      expect(
        controller.settings.isProfileActive(AccessibilityProfile.seizureSafe),
        isTrue,
      );
      expect(
        controller.settings.isProfileActive(AccessibilityProfile.adhd),
        isTrue,
      );
      expect(controller.settings.readingGuide, isTrue);
      expect(controller.settings.stopAnimations, isTrue);

      // Add Vision Impaired profile simultaneously
      controller.toggleProfile(AccessibilityProfile.visionImpaired);
      expect(controller.settings.activeProfiles.length, 3);
      expect(controller.settings.highContrast, isTrue);
      expect(controller.settings.textScale, 1.5);

      // Add Dyslexia profile as well (all 4 active at once)
      controller.toggleProfile(AccessibilityProfile.dyslexia);
      expect(controller.settings.activeProfiles.length, 4);
      expect(controller.settings.dyslexiaFont, isTrue);

      // Deselecting ADHD leaves the other 3 active
      controller.toggleProfile(AccessibilityProfile.adhd);
      expect(
        controller.settings.isProfileActive(AccessibilityProfile.adhd),
        isFalse,
      );
      expect(
        controller.settings.isProfileActive(AccessibilityProfile.seizureSafe),
        isTrue,
      );
      expect(
        controller.settings.isProfileActive(AccessibilityProfile.visionImpaired),
        isTrue,
      );
      expect(
        controller.settings.isProfileActive(AccessibilityProfile.dyslexia),
        isTrue,
      );
      expect(controller.settings.readingGuide, isFalse);
      expect(controller.settings.stopAnimations, isTrue);
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

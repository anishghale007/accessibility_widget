import 'package:flutter_test/flutter_test.dart';
import 'package:accessibility_widget/accessibility_widget.dart';

void main() {
  group('AccessibilitySettings', () {
    test('defaults are sane and baseline', () {
      const AccessibilitySettings settings = AccessibilitySettings.defaults;
      expect(settings.textScale, 1.0);
      expect(settings.boldText, isFalse);
      expect(settings.dyslexiaFont, isFalse);
      expect(settings.lineSpacing, 1.0);
      expect(settings.letterSpacing, 0.0);
      expect(settings.highContrast, isFalse);
      expect(settings.invertColors, isFalse);
      expect(settings.saturation, 1.0);
      expect(settings.darkMode, isNull);
      expect(settings.hideImages, isFalse);
      expect(settings.highlightLinks, isFalse);
      expect(settings.highlightTiles, isFalse);
      expect(settings.highlightHeadings, isFalse);
      expect(settings.readingGuide, isFalse);
      expect(settings.bigCursor, isFalse);
      expect(settings.stopAnimations, isFalse);
      expect(settings.hapticFeedback, isFalse);
      expect(settings.activeProfile, isNull);
    });

    test('toJson and fromJson serialize and deserialize correctly', () {
      const AccessibilitySettings original = AccessibilitySettings(
        textScale: 1.5,
        boldText: true,
        dyslexiaFont: true,
        lineSpacing: 1.8,
        letterSpacing: 2.0,
        highContrast: true,
        invertColors: true,
        saturation: 0.5,
        darkMode: true,
        hideImages: true,
        highlightLinks: true,
        highlightTiles: true,
        highlightHeadings: true,
        readingGuide: true,
        bigCursor: true,
        stopAnimations: true,
        hapticFeedback: true,
        activeProfiles: <AccessibilityProfile>{
          AccessibilityProfile.visionImpaired,
          AccessibilityProfile.dyslexia,
        },
      );

      final Map<String, dynamic> json = original.toJson();
      expect(json['textScale'], 1.5);
      expect(json['activeProfiles'], <String>['visionImpaired', 'dyslexia']);

      final AccessibilitySettings restored =
          AccessibilitySettings.fromJson(json);
      expect(restored, equals(original));
      expect(
        restored.isProfileActive(AccessibilityProfile.visionImpaired),
        isTrue,
      );
      expect(
        restored.isProfileActive(AccessibilityProfile.dyslexia),
        isTrue,
      );
    });

    test('fromJson handles legacy / missing fields gracefully', () {
      final Map<String, dynamic> legacyJson = <String, dynamic>{
        'textScale': 1.2,
        'boldText': true,
      };

      final AccessibilitySettings restored =
          AccessibilitySettings.fromJson(legacyJson);
      expect(restored.textScale, 1.2);
      expect(restored.boldText, isTrue);
      expect(restored.highlightTiles, isFalse);
      expect(restored.bigCursor, isFalse);
      expect(restored.hapticFeedback, isFalse);
      expect(restored.activeProfiles, isEmpty);
    });

    test('copyWith works and supports clearing nullable fields', () {
      const AccessibilitySettings settings = AccessibilitySettings(
        darkMode: true,
        activeProfiles: <AccessibilityProfile>{AccessibilityProfile.seizureSafe},
      );

      final AccessibilitySettings updated = settings.copyWith(
        clearDarkMode: true,
        clearActiveProfiles: true,
        textScale: 1.3,
      );

      expect(updated.darkMode, isNull);
      expect(updated.activeProfiles, isEmpty);
      expect(updated.textScale, 1.3);
    });
  });
}

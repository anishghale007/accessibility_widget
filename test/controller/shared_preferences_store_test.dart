import 'package:accessibility_widget/src/controller/stores/shared_preferences_accessibility_store.dart';
import 'package:accessibility_widget/src/models/accessibility_profile.dart';
import 'package:accessibility_widget/src/models/accessibility_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SharedPreferencesAccessibilityStore', () {
    setUp(() {
      SharedPreferences.setMockInitialValues(<String, Object>{});
    });

    test('writes and reads settings accurately', () async {
      final SharedPreferencesAccessibilityStore store =
          SharedPreferencesAccessibilityStore();

      expect(await store.read(), isNull);

      const AccessibilitySettings toSave = AccessibilitySettings(
        textScale: 1.4,
        highContrast: true,
        activeProfile: AccessibilityProfile.seizureSafe,
      );

      await store.write(toSave);
      final AccessibilitySettings? loaded = await store.read();

      expect(loaded, equals(toSave));
      expect(loaded?.textScale, 1.4);
      expect(loaded?.highContrast, isTrue);
      expect(loaded?.activeProfile, AccessibilityProfile.seizureSafe);
    });

    test('handles corrupt or empty string safely', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        SharedPreferencesAccessibilityStore.defaultStorageKey:
            'NOT_VALID_JSON{',
      });

      final SharedPreferencesAccessibilityStore store =
          SharedPreferencesAccessibilityStore();

      final AccessibilitySettings? loaded = await store.read();
      expect(loaded, isNull);
    });
  });
}

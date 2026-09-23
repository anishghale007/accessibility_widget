import 'package:flutter_test/flutter_test.dart';
import 'package:accessibility_widget/accessibility_widget.dart';

void main() {
  group('AccessibilityProfile', () {
    test('contains expected profile enums with labels', () {
      expect(AccessibilityProfile.values.length, 2);
      expect(AccessibilityProfile.seizureSafe.label, 'Seizure Safe');
      expect(AccessibilityProfile.visionImpaired.label, 'Vision Impaired');
      expect(AccessibilityProfile.seizureSafe.description, isNotEmpty);
      expect(AccessibilityProfile.visionImpaired.description, isNotEmpty);
    });
  });
}

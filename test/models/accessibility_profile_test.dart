import 'package:flutter_test/flutter_test.dart';
import 'package:accessibility_widget/accessibility_widget.dart';

void main() {
  group('AccessibilityProfile', () {
    test('contains expected profile enums with labels', () {
      expect(AccessibilityProfile.values.length, 4);
      expect(AccessibilityProfile.seizureSafe.label, 'Seizure Safe');
      expect(AccessibilityProfile.visionImpaired.label, 'Vision Impaired');
      expect(AccessibilityProfile.adhd.label, 'ADHD Friendly');
      expect(AccessibilityProfile.dyslexia.label, 'Dyslexia Friendly');
      expect(AccessibilityProfile.seizureSafe.description, isNotEmpty);
      expect(AccessibilityProfile.visionImpaired.description, isNotEmpty);
      expect(AccessibilityProfile.adhd.description, isNotEmpty);
      expect(AccessibilityProfile.dyslexia.description, isNotEmpty);
    });
  });
}

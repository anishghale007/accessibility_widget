/// Preset accessibility profiles that apply bundles of settings atomically.
enum AccessibilityProfile {
  /// Eliminates the risk of seizures triggered by flashing/blinking content
  /// and reduces visually intense color combinations.
  seizureSafe,

  /// Adjusts the app to be more usable for common visual impairments
  /// (e.g. degrading eyesight, tunnel vision, low contrast sensitivity).
  visionImpaired,

  /// Minimizes distractions with a focused reading guide and paused animations.
  adhd,

  /// Enhances readability using the Andika font, increased line height, letter spacing, and reduced animations.
  dyslexia;

  /// Returns the human-readable display title for this profile.
  String get label {
    switch (this) {
      case AccessibilityProfile.seizureSafe:
        return 'Seizure Safe';
      case AccessibilityProfile.visionImpaired:
        return 'Vision Impaired';
      case AccessibilityProfile.adhd:
        return 'ADHD Friendly';
      case AccessibilityProfile.dyslexia:
        return 'Dyslexia Friendly';
    }
  }

  /// Returns a concise description of what this profile adjusts.
  String get description {
    switch (this) {
      case AccessibilityProfile.seizureSafe:
        return 'Stops animations and reduces color saturation';
      case AccessibilityProfile.visionImpaired:
        return 'Enlarges text, increases contrast, and highlights navigation';
      case AccessibilityProfile.adhd:
        return 'Enables reading guide spotlight and stops animations';
      case AccessibilityProfile.dyslexia:
        return 'Enables Andika font, line height, letter spacing, and stops animations';
    }
  }
}

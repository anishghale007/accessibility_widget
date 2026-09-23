import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/accessibility_profile.dart';
import '../models/accessibility_settings.dart';
import 'stores/accessibility_store.dart';
import 'stores/shared_preferences_accessibility_store.dart';

/// State controller managing current accessibility settings, notifying listeners,
/// and persisting preferences asynchronously.
class AccessibilityController extends ChangeNotifier {
  AccessibilityController({
    AccessibilityStore? store,
    AccessibilitySettings initialSettings = AccessibilitySettings.defaults,
  })  : _store = store ?? SharedPreferencesAccessibilityStore(),
        _settings = initialSettings;

  final AccessibilityStore _store;
  AccessibilitySettings _settings;

  /// The active accessibility configuration.
  AccessibilitySettings get settings => _settings;

  /// Restores persisted preferences from the store.
  /// Safe to call before or after UI renders.
  Future<void> restore() async {
    try {
      final AccessibilitySettings? loaded = await _store.read();
      if (loaded != null) {
        _settings = loaded;
        notifyListeners();
      }
    } catch (_) {
      // Fallback gracefully on storage error
    }
  }

  /// Replaces the current settings and triggers an unawaited persistent write.
  void update(AccessibilitySettings newSettings) {
    if (_settings == newSettings) return;
    _settings = newSettings;
    notifyListeners();
    unawaited(_store.write(_settings));
  }

  /// Sets text scale multiplier and clears active profile indicator.
  void setTextScale(double scale) {
    update(_settings.copyWith(
      textScale: scale,
      clearActiveProfile: true,
    ));
  }

  /// Toggles bold text styling and clears active profile indicator.
  void toggleBoldText() {
    update(_settings.copyWith(
      boldText: !_settings.boldText,
      clearActiveProfile: true,
    ));
  }

  /// Toggles dyslexia-friendly typography and clears active profile indicator.
  void toggleDyslexiaFont() {
    update(_settings.copyWith(
      dyslexiaFont: !_settings.dyslexiaFont,
      clearActiveProfile: true,
    ));
  }

  /// Sets additional line spacing multiplier and clears active profile indicator.
  void setLineSpacing(double spacing) {
    update(_settings.copyWith(
      lineSpacing: spacing,
      clearActiveProfile: true,
    ));
  }

  /// Sets additional letter spacing and clears active profile indicator.
  void setLetterSpacing(double spacing) {
    update(_settings.copyWith(
      letterSpacing: spacing,
      clearActiveProfile: true,
    ));
  }

  /// Toggles high contrast mode and clears active profile indicator.
  void toggleHighContrast() {
    update(_settings.copyWith(
      highContrast: !_settings.highContrast,
      clearActiveProfile: true,
    ));
  }

  /// Toggles screen color inversion and clears active profile indicator.
  void toggleInvertColors() {
    update(_settings.copyWith(
      invertColors: !_settings.invertColors,
      clearActiveProfile: true,
    ));
  }

  /// Sets color saturation multiplier and clears active profile indicator.
  void setSaturation(double saturation) {
    update(_settings.copyWith(
      saturation: saturation,
      clearActiveProfile: true,
    ));
  }

  /// Sets dark mode override and clears active profile indicator.
  void setDarkMode(bool? darkMode) {
    update(_settings.copyWith(
      darkMode: darkMode,
      clearDarkMode: darkMode == null,
      clearActiveProfile: true,
    ));
  }

  /// Toggles image hiding and clears active profile indicator.
  void toggleHideImages() {
    update(_settings.copyWith(
      hideImages: !_settings.hideImages,
      clearActiveProfile: true,
    ));
  }

  /// Toggles link highlighting and clears active profile indicator.
  void toggleHighlightLinks() {
    update(_settings.copyWith(
      highlightLinks: !_settings.highlightLinks,
      clearActiveProfile: true,
    ));
  }

  /// Toggles card/tile highlighting and clears active profile indicator.
  void toggleHighlightTiles() {
    update(_settings.copyWith(
      highlightTiles: !_settings.highlightTiles,
      clearActiveProfile: true,
    ));
  }

  /// Toggles heading highlighting and clears active profile indicator.
  void toggleHighlightHeadings() {
    update(_settings.copyWith(
      highlightHeadings: !_settings.highlightHeadings,
      clearActiveProfile: true,
    ));
  }

  /// Toggles reading guide overlay and clears active profile indicator.
  void toggleReadingGuide() {
    update(_settings.copyWith(
      readingGuide: !_settings.readingGuide,
      clearActiveProfile: true,
    ));
  }

  /// Toggles enlarged cursor follower and clears active profile indicator.
  void toggleBigCursor() {
    update(_settings.copyWith(
      bigCursor: !_settings.bigCursor,
      clearActiveProfile: true,
    ));
  }

  /// Toggles motion/animations reduction and clears active profile indicator.
  void toggleReduceMotion() {
    update(_settings.copyWith(
      stopAnimations: !_settings.stopAnimations,
      clearActiveProfile: true,
    ));
  }

  /// Alias for [toggleReduceMotion].
  void toggleStopAnimations() => toggleReduceMotion();

  /// Toggles haptic feedback on interactive elements and clears active profile indicator.
  void toggleHapticFeedback() {
    update(_settings.copyWith(
      hapticFeedback: !_settings.hapticFeedback,
      clearActiveProfile: true,
    ));
  }

  /// Atomically applies a preset profile bundle of settings.
  ///
  /// If the specified [profile] is already active, calling this disables it
  /// and resets all settings back to default values.
  void applyProfile(AccessibilityProfile profile) {
    if (_settings.activeProfile == profile) {
      reset();
      return;
    }

    switch (profile) {
      case AccessibilityProfile.seizureSafe:
        update(AccessibilitySettings.defaults.copyWith(
          stopAnimations: true,
          saturation: 0.5,
          invertColors: false,
          highContrast: false,
          activeProfile: AccessibilityProfile.seizureSafe,
        ));
        break;
      case AccessibilityProfile.visionImpaired:
        update(AccessibilitySettings.defaults.copyWith(
          textScale: 1.5,
          highContrast: true,
          boldText: true,
          highlightLinks: true,
          highlightTiles: true,
          highlightHeadings: true,
          bigCursor: true,
          activeProfile: AccessibilityProfile.visionImpaired,
        ));
        break;
      case AccessibilityProfile.adhd:
        update(AccessibilitySettings.defaults.copyWith(
          readingGuide: true,
          stopAnimations: true,
          activeProfile: AccessibilityProfile.adhd,
        ));
        break;
      case AccessibilityProfile.dyslexia:
        update(AccessibilitySettings.defaults.copyWith(
          dyslexiaFont: true,
          lineSpacing: 1.5,
          letterSpacing: 1.2,
          stopAnimations: true,
          activeProfile: AccessibilityProfile.dyslexia,
        ));
        break;
    }
  }

  /// Resets all settings back to default baseline values and clears active profile.
  void reset() {
    update(AccessibilitySettings.defaults);
  }
}

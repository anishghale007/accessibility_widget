import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/accessibility_scope.dart';
import 'platform.dart';

/// Utility class providing tactile / haptic feedback conditionally based on user settings.
class AccessibilityHaptics {
  const AccessibilityHaptics._();

  /// Triggers a subtle tactile feedback if [AccessibilitySettings.hapticFeedback] is enabled.
  ///
  /// Safe to call anywhere in the widget tree. On Flutter Web, vibration calls are
  /// gracefully inert and will not throw.
  static void maybeVibrate(BuildContext context) {
    final bool isEnabled = AccessibilityScope.maybeOf(context)?.settings.hapticFeedback ?? false;
    if (isEnabled) {
      triggerFeedback();
    }
  }

  /// Directly triggers the standard accessibility tactile feedback without checking scope.
  static void triggerFeedback({PlatformInfo platform = PlatformInfo.current}) {
    if (platform.isWeb) {
      // Browsers do not support HapticFeedback; silently inert.
      return;
    }
    try {
      HapticFeedback.selectionClick();
    } catch (_) {
      // Swallowed safely if device does not support haptics
    }
  }
}

import 'dart:async';
import '../../models/accessibility_settings.dart';

/// Abstract storage interface for reading and writing accessibility preferences.
abstract class AccessibilityStore {
  /// Reads the persisted settings from the underlying store.
  /// Returns `null` if no settings have been saved yet.
  Future<AccessibilitySettings?> read();

  /// Writes the current settings to the underlying store.
  Future<void> write(AccessibilitySettings settings);
}

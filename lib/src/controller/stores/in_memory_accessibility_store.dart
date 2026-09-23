import 'dart:async';
import '../../models/accessibility_settings.dart';
import 'accessibility_store.dart';

/// In-memory implementation of [AccessibilityStore] useful for unit testing
/// or running without disk persistence.
class InMemoryAccessibilityStore implements AccessibilityStore {
  InMemoryAccessibilityStore([this._storedSettings]);

  AccessibilitySettings? _storedSettings;

  @override
  Future<AccessibilitySettings?> read() async {
    return _storedSettings;
  }

  @override
  Future<void> write(AccessibilitySettings settings) async {
    _storedSettings = settings;
  }
}

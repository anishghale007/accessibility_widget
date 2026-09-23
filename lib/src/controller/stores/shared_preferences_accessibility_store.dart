import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/accessibility_settings.dart';
import 'accessibility_store.dart';

/// Persistent implementation of [AccessibilityStore] backed by `shared_preferences`.
/// Serializes all preferences into a single JSON blob under a dedicated key.
class SharedPreferencesAccessibilityStore implements AccessibilityStore {
  SharedPreferencesAccessibilityStore({
    this.storageKey = defaultStorageKey,
    SharedPreferences? preferencesInstance,
  }) : _prefs = preferencesInstance;

  /// Default SharedPreferences key used to persist accessibility settings.
  static const String defaultStorageKey = 'accessibility_widget.settings';

  /// The preference key where settings JSON is saved.
  final String storageKey;

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    final SharedPreferences? instance = _prefs;
    if (instance != null) {
      return instance;
    }
    final SharedPreferences loaded = await SharedPreferences.getInstance();
    _prefs = loaded;
    return loaded;
  }

  @override
  Future<AccessibilitySettings?> read() async {
    try {
      final SharedPreferences prefs = await _getPrefs();
      final String? jsonString = prefs.getString(storageKey);
      if (jsonString == null || jsonString.isEmpty) {
        return null;
      }
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is Map<String, dynamic>) {
        return AccessibilitySettings.fromJson(decoded);
      } else if (decoded is Map) {
        return AccessibilitySettings.fromJson(
            Map<String, dynamic>.from(decoded));
      }
      return null;
    } catch (_) {
      // In case of corrupt data, fallback safely
      return null;
    }
  }

  @override
  Future<void> write(AccessibilitySettings settings) async {
    try {
      final SharedPreferences prefs = await _getPrefs();
      final String jsonString = jsonEncode(settings.toJson());
      await prefs.setString(storageKey, jsonString);
    } catch (_) {
      // Swallowed safely so disk write failure does not crash the UI thread
    }
  }
}

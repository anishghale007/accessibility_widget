import 'package:flutter/foundation.dart';

/// Helper abstraction for platform checks to enable testing and platform-branching logic.
class PlatformInfo {
  const PlatformInfo();

  /// Test override for `isWeb`.
  @visibleForTesting
  static bool? debugIsWebOverride;

  /// Test override for `isMobile`.
  @visibleForTesting
  static bool? debugIsMobileOverride;

  /// Whether the host application is running on Flutter Web.
  bool get isWeb => debugIsWebOverride ?? kIsWeb;

  /// Whether the host application is running on a mobile platform (Android or iOS).
  bool get isMobile {
    if (debugIsMobileOverride != null) return debugIsMobileOverride!;
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// Default singleton instance.
  static const PlatformInfo current = PlatformInfo();
}

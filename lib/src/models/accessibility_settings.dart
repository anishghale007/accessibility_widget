import 'package:flutter/foundation.dart';
import 'accessibility_profile.dart';

/// Immutable configuration representation of all user-selected accessibility preferences.
@immutable
class AccessibilitySettings {
  const AccessibilitySettings({
    this.textScale = 1.0,
    this.boldText = false,
    this.dyslexiaFont = false,
    this.lineSpacing = 1.0,
    this.letterSpacing = 0.0,
    this.highContrast = false,
    this.invertColors = false,
    this.saturation = 1.0,
    this.darkMode,
    this.hideImages = false,
    this.highlightLinks = false,
    this.highlightTiles = false,
    this.highlightHeadings = false,
    this.readingGuide = false,
    this.bigCursor = false,
    this.stopAnimations = false,
    this.hapticFeedback = false,
    this.activeProfile,
  });

  /// The text scale factor multiplier (e.g. 1.0 to 2.0).
  final double textScale;

  /// Whether text should be rendered with a heavier font weight.
  final bool boldText;

  /// Whether to switch typography to a dyslexia-friendly font style.
  final bool dyslexiaFont;

  /// Additional line spacing multiplier.
  final double lineSpacing;

  /// Additional letter spacing in pixels.
  final double letterSpacing;

  /// Whether high-contrast mode is enabled.
  final bool highContrast;

  /// Whether screen colors are inverted.
  final bool invertColors;

  /// Color saturation multiplier (0.0 for grayscale, 1.0 for normal).
  final double saturation;

  /// Optional override for dark mode (true = force dark, false = force light, null = follow system/theme).
  final bool? darkMode;

  /// Whether images should be hidden and replaced with accessible placeholders.
  final bool hideImages;

  /// Whether interactive links and navigation actions should be visually highlighted.
  final bool highlightLinks;

  /// Whether card and list item boundaries should be visually highlighted.
  final bool highlightTiles;

  /// Whether headings and section titles should be visually highlighted.
  final bool highlightHeadings;

  /// Whether the horizontal reading guide overlay is enabled.
  final bool readingGuide;

  /// Whether the enlarged cursor follower is enabled (meaningful only on Web).
  final bool bigCursor;

  /// Whether animations and motion should be reduced/stopped.
  final bool stopAnimations;

  /// Whether tactile/vibrational feedback should trigger on interactive element taps.
  final bool hapticFeedback;

  /// Currently active preset profile, or null if custom/no profile is active.
  final AccessibilityProfile? activeProfile;

  /// Default baseline settings with no accessibility adjustments applied.
  static const AccessibilitySettings defaults = AccessibilitySettings();

  /// Creates a copy of this settings instance with specified fields replaced.
  AccessibilitySettings copyWith({
    double? textScale,
    bool? boldText,
    bool? dyslexiaFont,
    double? lineSpacing,
    double? letterSpacing,
    bool? highContrast,
    bool? invertColors,
    double? saturation,
    bool? darkMode,
    bool? clearDarkMode,
    bool? hideImages,
    bool? highlightLinks,
    bool? highlightTiles,
    bool? highlightHeadings,
    bool? readingGuide,
    bool? bigCursor,
    bool? stopAnimations,
    bool? hapticFeedback,
    AccessibilityProfile? activeProfile,
    bool clearActiveProfile = false,
  }) {
    return AccessibilitySettings(
      textScale: textScale ?? this.textScale,
      boldText: boldText ?? this.boldText,
      dyslexiaFont: dyslexiaFont ?? this.dyslexiaFont,
      lineSpacing: lineSpacing ?? this.lineSpacing,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      highContrast: highContrast ?? this.highContrast,
      invertColors: invertColors ?? this.invertColors,
      saturation: saturation ?? this.saturation,
      darkMode: clearDarkMode == true ? null : (darkMode ?? this.darkMode),
      hideImages: hideImages ?? this.hideImages,
      highlightLinks: highlightLinks ?? this.highlightLinks,
      highlightTiles: highlightTiles ?? this.highlightTiles,
      highlightHeadings: highlightHeadings ?? this.highlightHeadings,
      readingGuide: readingGuide ?? this.readingGuide,
      bigCursor: bigCursor ?? this.bigCursor,
      stopAnimations: stopAnimations ?? this.stopAnimations,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      activeProfile: clearActiveProfile ? null : (activeProfile ?? this.activeProfile),
    );
  }

  /// Serializes this instance to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'textScale': textScale,
      'boldText': boldText,
      'dyslexiaFont': dyslexiaFont,
      'lineSpacing': lineSpacing,
      'letterSpacing': letterSpacing,
      'highContrast': highContrast,
      'invertColors': invertColors,
      'saturation': saturation,
      'darkMode': darkMode,
      'hideImages': hideImages,
      'highlightLinks': highlightLinks,
      'highlightTiles': highlightTiles,
      'highlightHeadings': highlightHeadings,
      'readingGuide': readingGuide,
      'bigCursor': bigCursor,
      'stopAnimations': stopAnimations,
      'hapticFeedback': hapticFeedback,
      'activeProfile': activeProfile?.name,
    };
  }

  /// Deserializes an instance from a JSON map with safe fallback defaults.
  factory AccessibilitySettings.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return defaults;
    }

    AccessibilityProfile? profile;
    final dynamic rawProfile = json['activeProfile'];
    if (rawProfile is String) {
      for (final AccessibilityProfile p in AccessibilityProfile.values) {
        if (p.name == rawProfile) {
          profile = p;
          break;
        }
      }
    }

    return AccessibilitySettings(
      textScale: (json['textScale'] as num?)?.toDouble() ?? 1.0,
      boldText: json['boldText'] as bool? ?? false,
      dyslexiaFont: json['dyslexiaFont'] as bool? ?? false,
      lineSpacing: (json['lineSpacing'] as num?)?.toDouble() ?? 1.0,
      letterSpacing: (json['letterSpacing'] as num?)?.toDouble() ?? 0.0,
      highContrast: json['highContrast'] as bool? ?? false,
      invertColors: json['invertColors'] as bool? ?? false,
      saturation: (json['saturation'] as num?)?.toDouble() ?? 1.0,
      darkMode: json['darkMode'] as bool?,
      hideImages: json['hideImages'] as bool? ?? false,
      highlightLinks: json['highlightLinks'] as bool? ?? false,
      highlightTiles: json['highlightTiles'] as bool? ?? false,
      highlightHeadings: json['highlightHeadings'] as bool? ?? false,
      readingGuide: json['readingGuide'] as bool? ?? false,
      bigCursor: json['bigCursor'] as bool? ?? false,
      stopAnimations: json['stopAnimations'] as bool? ?? false,
      hapticFeedback: json['hapticFeedback'] as bool? ?? false,
      activeProfile: profile,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AccessibilitySettings &&
        other.textScale == textScale &&
        other.boldText == boldText &&
        other.dyslexiaFont == dyslexiaFont &&
        other.lineSpacing == lineSpacing &&
        other.letterSpacing == letterSpacing &&
        other.highContrast == highContrast &&
        other.invertColors == invertColors &&
        other.saturation == saturation &&
        other.darkMode == darkMode &&
        other.hideImages == hideImages &&
        other.highlightLinks == highlightLinks &&
        other.highlightTiles == highlightTiles &&
        other.highlightHeadings == highlightHeadings &&
        other.readingGuide == readingGuide &&
        other.bigCursor == bigCursor &&
        other.stopAnimations == stopAnimations &&
        other.hapticFeedback == hapticFeedback &&
        other.activeProfile == activeProfile;
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
        textScale,
        boldText,
        dyslexiaFont,
        lineSpacing,
        letterSpacing,
        highContrast,
        invertColors,
        saturation,
        darkMode,
        hideImages,
        highlightLinks,
        highlightTiles,
        highlightHeadings,
        readingGuide,
        bigCursor,
        stopAnimations,
        hapticFeedback,
        activeProfile,
      ]);

  @override
  String toString() {
    return 'AccessibilitySettings('
        'textScale: $textScale, '
        'boldText: $boldText, '
        'dyslexiaFont: $dyslexiaFont, '
        'lineSpacing: $lineSpacing, '
        'letterSpacing: $letterSpacing, '
        'highContrast: $highContrast, '
        'invertColors: $invertColors, '
        'saturation: $saturation, '
        'darkMode: $darkMode, '
        'hideImages: $hideImages, '
        'highlightLinks: $highlightLinks, '
        'highlightTiles: $highlightTiles, '
        'highlightHeadings: $highlightHeadings, '
        'readingGuide: $readingGuide, '
        'bigCursor: $bigCursor, '
        'stopAnimations: $stopAnimations, '
        'hapticFeedback: $hapticFeedback, '
        'activeProfile: $activeProfile'
        ')';
  }
}

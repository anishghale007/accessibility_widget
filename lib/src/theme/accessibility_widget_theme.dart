import 'package:flutter/material.dart';

/// Visual customization theme for the accessibility widget, panel, and highlight overlays.
@immutable
class AccessibilityWidgetTheme {
  const AccessibilityWidgetTheme({
    this.fabBackgroundColor,
    this.fabForegroundColor,
    this.fabIcon = Icons.accessibility_new,
    this.fabShape = const CircleBorder(),
    this.panelBackgroundColor,
    this.panelHeaderColor,
    this.accentColor,
    this.cardBackgroundColor,
    this.titleStyle,
    this.sectionTitleStyle,
    this.bodyStyle,
  });

  /// Background color of the floating action button.
  final Color? fabBackgroundColor;

  /// Foreground / icon color of the floating action button.
  final Color? fabForegroundColor;

  /// Custom icon for the floating action button.
  final IconData fabIcon;

  /// Custom shape for the floating action button (defaults to [CircleBorder]).
  final ShapeBorder? fabShape;

  /// Background color of the settings panel or bottom sheet.
  final Color? panelBackgroundColor;

  /// Background/accent color of the settings header.
  final Color? panelHeaderColor;

  /// Highlight and accent color used for link/tile/heading visual highlights.
  final Color? accentColor;

  /// Background color for cards and profile selection chips in the panel.
  final Color? cardBackgroundColor;

  /// Text style for panel title.
  final TextStyle? titleStyle;

  /// Text style for panel section headers.
  final TextStyle? sectionTitleStyle;

  /// Text style for label/body content inside the panel.
  final TextStyle? bodyStyle;

  /// Creates a copy of this theme with specified properties overridden.
  AccessibilityWidgetTheme copyWith({
    Color? fabBackgroundColor,
    Color? fabForegroundColor,
    IconData? fabIcon,
    ShapeBorder? fabShape,
    Color? panelBackgroundColor,
    Color? panelHeaderColor,
    Color? accentColor,
    Color? cardBackgroundColor,
    TextStyle? titleStyle,
    TextStyle? sectionTitleStyle,
    TextStyle? bodyStyle,
  }) {
    return AccessibilityWidgetTheme(
      fabBackgroundColor: fabBackgroundColor ?? this.fabBackgroundColor,
      fabForegroundColor: fabForegroundColor ?? this.fabForegroundColor,
      fabIcon: fabIcon ?? this.fabIcon,
      fabShape: fabShape ?? this.fabShape,
      panelBackgroundColor: panelBackgroundColor ?? this.panelBackgroundColor,
      panelHeaderColor: panelHeaderColor ?? this.panelHeaderColor,
      accentColor: accentColor ?? this.accentColor,
      cardBackgroundColor: cardBackgroundColor ?? this.cardBackgroundColor,
      titleStyle: titleStyle ?? this.titleStyle,
      sectionTitleStyle: sectionTitleStyle ?? this.sectionTitleStyle,
      bodyStyle: bodyStyle ?? this.bodyStyle,
    );
  }

  /// Resolves effective colors and text styles by falling back to ambient [ThemeData].
  AccessibilityWidgetTheme resolveWith(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return AccessibilityWidgetTheme(
      fabBackgroundColor: fabBackgroundColor ?? colorScheme.primary,
      fabForegroundColor: fabForegroundColor ?? colorScheme.onPrimary,
      fabIcon: fabIcon,
      fabShape: fabShape ?? const CircleBorder(),
      panelBackgroundColor:
          panelBackgroundColor ?? theme.scaffoldBackgroundColor,
      panelHeaderColor: panelHeaderColor ?? colorScheme.surface,
      accentColor: accentColor ?? colorScheme.primary,
      cardBackgroundColor:
          cardBackgroundColor ?? colorScheme.surfaceContainerHighest,
      titleStyle: titleStyle ??
          theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      sectionTitleStyle: sectionTitleStyle ??
          theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold, color: colorScheme.primary),
      bodyStyle: bodyStyle ?? theme.textTheme.bodyMedium,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AccessibilityWidgetTheme &&
        other.fabBackgroundColor == fabBackgroundColor &&
        other.fabForegroundColor == fabForegroundColor &&
        other.fabIcon == fabIcon &&
        other.fabShape == fabShape &&
        other.panelBackgroundColor == panelBackgroundColor &&
        other.panelHeaderColor == panelHeaderColor &&
        other.accentColor == accentColor &&
        other.cardBackgroundColor == cardBackgroundColor &&
        other.titleStyle == titleStyle &&
        other.sectionTitleStyle == sectionTitleStyle &&
        other.bodyStyle == bodyStyle;
  }

  @override
  int get hashCode => Object.hash(
        fabBackgroundColor,
        fabForegroundColor,
        fabIcon,
        fabShape,
        panelBackgroundColor,
        panelHeaderColor,
        accentColor,
        cardBackgroundColor,
        titleStyle,
        sectionTitleStyle,
        bodyStyle,
      );
}

import 'package:flutter/material.dart';
import '../theme/accessibility_widget_theme.dart';
import '../utils/accessibility_haptics.dart';
import 'accessibility_scope.dart';

/// An accessible tile wrapper widget that highlights card/list item boundaries
/// when [AccessibilitySettings.highlightTiles] is active.
///
/// Supports optional tactile haptic feedback when tapped if `onTap` is provided.
class AccessibleTile extends StatelessWidget {
  const AccessibleTile({
    super.key,
    required this.child,
    this.onTap,
    this.highlightColor,
    this.borderRadius,
    this.borderWidth = 2.0,
  });

  /// The wrapped card, list item, or custom container widget.
  final Widget child;

  /// Optional tap handler. When provided, tapping triggers conditional haptic feedback.
  final VoidCallback? onTap;

  /// Custom highlight color. Defaults to theme accent color or primary color.
  final Color? highlightColor;

  /// Optional corner radius for the highlight outline. Defaults to 8px.
  final BorderRadiusGeometry? borderRadius;

  /// Outline width when highlighted. Defaults to 2.0.
  final double borderWidth;

  void _handleTap(BuildContext context) {
    if (onTap == null) return;
    AccessibilityHaptics.maybeVibrate(context);
    onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final AccessibilityScope? scope = AccessibilityScope.maybeOf(context);
    final bool isHighlighted = scope?.settings.highlightTiles ?? false;

    if (!isHighlighted) {
      if (onTap != null) {
        return GestureDetector(
          onTap: () => _handleTap(context),
          behavior: HitTestBehavior.opaque,
          child: child,
        );
      }
      return child;
    }

    final ThemeData theme = Theme.of(context);
    final AccessibilityWidgetTheme? widgetTheme = scope?.theme;
    final Color effectiveColor = highlightColor ??
        widgetTheme?.accentColor ??
        theme.colorScheme.primary;

    final BorderRadiusGeometry effectiveRadius =
        borderRadius ?? BorderRadius.circular(8.0);

    Widget content = DecoratedBox(
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: 0.08),
        borderRadius: effectiveRadius,
        border: Border.all(
          color: effectiveColor,
          width: borderWidth,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: () => _handleTap(context),
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}

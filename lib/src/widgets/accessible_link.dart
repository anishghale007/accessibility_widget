import 'package:flutter/material.dart';
import '../theme/accessibility_widget_theme.dart';
import '../utils/accessibility_haptics.dart';
import 'accessibility_scope.dart';

/// An accessible link wrapper widget that highlights navigation and link elements
/// when [AccessibilitySettings.highlightLinks] is active.
///
/// Supports optional tactile haptic feedback when tapped if `onTap` is provided.
class AccessibleLink extends StatelessWidget {
  const AccessibleLink({
    super.key,
    required this.child,
    this.onTap,
    this.highlightColor,
    this.showIcon = true,
    this.icon = Icons.open_in_new,
  });

  /// The wrapped widget (e.g. [Text], [InkWell], or custom link component).
  final Widget child;

  /// Optional tap handler. When provided, tapping this link triggers
  /// conditional haptic feedback before calling [onTap].
  final VoidCallback? onTap;

  /// Custom highlight color. Defaults to theme accent color or primary color.
  final Color? highlightColor;

  /// Whether to append a small link icon when highlighted.
  final bool showIcon;

  /// Icon to display when [showIcon] is true and highlighted.
  final IconData icon;

  void _handleTap(BuildContext context) {
    if (onTap == null) return;
    AccessibilityHaptics.maybeVibrate(context);
    onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final AccessibilityScope? scope = AccessibilityScope.maybeOf(context);
    final bool isHighlighted = scope?.settings.highlightLinks ?? false;

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

    Widget content = DefaultTextStyle.merge(
      style: TextStyle(
        color: effectiveColor,
        decoration: TextDecoration.underline,
        decorationColor: effectiveColor,
        decorationThickness: 2.0,
        fontWeight: FontWeight.w600,
      ),
      child: showIcon
          ? Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(child: child),
                const SizedBox(width: 4),
                Icon(
                  icon,
                  size: 14,
                  color: effectiveColor,
                ),
              ],
            )
          : child,
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

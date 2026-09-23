import 'package:flutter/material.dart';
import '../theme/accessibility_widget_theme.dart';
import 'accessibility_scope.dart';

/// An accessible heading wrapper widget that provides unconditional screen-reader heading
/// semantics and optional visual accent highlighting when [AccessibilitySettings.highlightHeadings] is on.
class AccessibleHeading extends StatelessWidget {
  const AccessibleHeading({
    super.key,
    required this.child,
    this.level = 1,
    this.highlightColor,
    this.showAccentBar = true,
  }) : assert(
            level >= 1 && level <= 6, 'Heading level must be between 1 and 6');

  /// The wrapped text or heading content.
  final Widget child;

  /// Heading hierarchy level (1 to 6, where 1 is the most prominent).
  final int level;

  /// Custom highlight color. Defaults to theme accent color or primary color.
  final Color? highlightColor;

  /// Whether to render a left accent bar next to the heading when highlighted.
  final bool showAccentBar;

  @override
  Widget build(BuildContext context) {
    final AccessibilityScope? scope = AccessibilityScope.maybeOf(context);
    final bool isHighlighted = scope?.settings.highlightHeadings ?? false;

    // Enforce Semantics(header: true) unconditionally for accessibility best practices
    if (!isHighlighted) {
      return Semantics(
        header: true,
        child: child,
      );
    }

    final ThemeData theme = Theme.of(context);
    final AccessibilityWidgetTheme? widgetTheme = scope?.theme;
    final Color effectiveColor =
        highlightColor ?? widgetTheme?.accentColor ?? theme.colorScheme.primary;

    // Scale styling according to heading level (h1 is thicker and larger than h6)
    final double barWidth = (7 - level) * 0.8;
    final double letterSpacing = (7 - level) * 0.2;

    Widget styledChild = DefaultTextStyle.merge(
      style: TextStyle(
        fontWeight: FontWeight.bold,
        letterSpacing: letterSpacing,
      ),
      child: child,
    );

    if (showAccentBar) {
      styledChild = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: barWidth.clamp(2.5, 6.0),
            height: 18.0 + (6 - level) * 2.5,
            margin: const EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
              color: effectiveColor,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          Flexible(child: styledChild),
        ],
      );
    }

    return Semantics(
      header: true,
      child: styledChild,
    );
  }
}

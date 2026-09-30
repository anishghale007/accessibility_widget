import 'package:flutter/material.dart';
import '../utils/accessibility_haptics.dart';
import 'accessibility_scope.dart';

/// An accessible link wrapper widget that highlights navigation and link elements
/// when [AccessibilitySettings.highlightLinks] is active.
///
/// Supports optional tactile haptic feedback when tapped if `onTap` is provided.
class AccessibleLink extends StatelessWidget {
  const AccessibleLink({
    required this.child,
    this.highlightColor,
    this.showIcon = true,
    this.icon = Icons.open_in_new,
    this.onTap,
    super.key,
  });

  /// The wrapped widget (e.g. [Text], [InkWell], or custom link component).
  final Widget child;

  /// Optional tap handler. When provided, tapping this link triggers
  /// conditional haptic feedback before calling [onTap].
  final VoidCallback? onTap;

  /// Custom highlight color. Defaults to WCAG yellow highlighter (#FFEB3B).
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

    // WCAG-compliant bright highlighter yellow for maximum visibility & contrast
    final Color effectiveHighlightBg = highlightColor ?? const Color(0xFFFFEB3B);

    const Color textColor = Colors.black;

    Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
      decoration: BoxDecoration(
        color: effectiveHighlightBg,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: Colors.black,
          width: 1.5,
        ),
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(
          color: textColor,
          decoration: TextDecoration.underline,
          decorationColor: textColor,
          decorationThickness: 2.0,
          fontWeight: FontWeight.bold,
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
                    color: textColor,
                  ),
                ],
              )
            : child,
      ),
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

import 'package:flutter/material.dart';
import 'accessibility_scope.dart';

/// An accessible image wrapper widget that respects the [AccessibilitySettings.hideImages] preference.
///
/// When `hideImages` is enabled, this widget replaces the image with an accessible placeholder
/// carrying a semantic label. When disabled, the child image renders normally.
class AccessibleImage extends StatelessWidget {
  const AccessibleImage({
    required this.child,
    this.semanticLabel = 'Image hidden',
    this.width,
    this.height,
    this.placeholder,
    super.key,
  });

  /// The original image widget to render when images are visible.
  final Widget child;

  /// Optional width for the placeholder when image is hidden.
  final double? width;

  /// Optional height for the placeholder when image is hidden.
  final double? height;

  /// Optional custom placeholder widget.
  final Widget? placeholder;

  /// Accessibility semantic label announced by screen readers when the image is hidden.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final bool hideImages =
        AccessibilityScope.maybeOf(context)?.settings.hideImages ?? false;

    if (!hideImages) {
      return child;
    }

    if (placeholder != null) {
      return Semantics(
        label: semanticLabel,
        child: placeholder,
      );
    }

    final ThemeData theme = Theme.of(context);
    return Semantics(
      container: true,
      label: semanticLabel,
      child: Container(
        width: width,
        height: height ?? 120,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.dividerColor,
            width: 1.0,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.image_not_supported_outlined,
              size: 32,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 6),
            ExcludeSemantics(
              child: Text(
                semanticLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

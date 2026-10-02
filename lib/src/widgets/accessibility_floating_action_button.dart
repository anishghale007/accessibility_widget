import 'package:flutter/material.dart';
import 'accessibility_bottom_sheet.dart';

/// A dedicated floating action button that triggers the accessibility preferences sheet or popup.
///
/// Can be passed directly to [Scaffold.floatingActionButton].
class AccessibilityFloatingActionButton extends StatelessWidget {
  const AccessibilityFloatingActionButton({
    super.key,
    this.icon = Icons.accessibility_new,
    this.heroTag = 'accessibility_widget_fab',
    this.tooltip = 'Accessibility preferences',
    this.backgroundColor,
    this.foregroundColor,
    this.shape = const CircleBorder(),
    this.alignment = Alignment.bottomRight,
    this.margin = const EdgeInsets.all(16.0),
    this.navigatorKey,
    this.onPressed,
  });

  /// Icon displayed inside the button. Defaults to [Icons.accessibility_new].
  final IconData icon;

  /// Hero tag for the floating action button. Defaults to `'accessibility_widget_fab'`.
  final Object? heroTag;

  /// Accessibility tooltip text.
  final String? tooltip;

  /// Background color override for the button. Defaults to the theme's primary color.
  final Color? backgroundColor;

  /// Icon / foreground color override. Defaults to the theme's onPrimary color.
  final Color? foregroundColor;

  /// Custom shape for the button. Defaults to [CircleBorder].
  final ShapeBorder? shape;

  /// Alignment anchor on Web/Desktop when opening as a popup.
  final Alignment alignment;

  /// Margin anchor on Web/Desktop when opening as a popup.
  final EdgeInsets margin;

  /// Optional [GlobalKey<NavigatorState>] to locate the active [Navigator] when placed
  /// globally in [MaterialApp.builder] outside the route hierarchy.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Custom click handler. If not specified, defaults to opening [AccessibilityBottomSheet.show].
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool hasOverlay = Overlay.maybeOf(context) != null;

    return ValueListenableBuilder<bool>(
      valueListenable: AccessibilityBottomSheet.isOpenNotifier,
      builder: (BuildContext context, bool isOpen, Widget? _) {
        final Widget fab = FloatingActionButton(
          heroTag: heroTag,
          tooltip: (hasOverlay && !isOpen) ? tooltip : null,
          shape: shape,
          backgroundColor: backgroundColor ?? colorScheme.primary,
          foregroundColor: foregroundColor ?? colorScheme.onPrimary,
          onPressed: isOpen
              ? null
              : (onPressed ??
                  () {
                    final BuildContext effectiveContext =
                        navigatorKey?.currentContext ?? context;
                    AccessibilityBottomSheet.show(
                      effectiveContext,
                      alignment: alignment,
                      margin: margin,
                    );
                  }),
          child: Icon(icon),
        );

        Widget result = AnimatedScale(
          scale: isOpen ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            opacity: isOpen ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: isOpen,
              child: fab,
            ),
          ),
        );

        if (!hasOverlay && tooltip != null && tooltip!.isNotEmpty && !isOpen) {
          result = Semantics(
            label: tooltip,
            button: true,
            child: result,
          );
        }

        return result;
      },
    );
  }
}

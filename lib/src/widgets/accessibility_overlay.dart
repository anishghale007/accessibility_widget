import 'package:flutter/material.dart';
import '../controller/accessibility_controller.dart';
import '../models/accessibility_settings.dart';
import '../theme/accessibility_widget_theme.dart';
import 'accessibility_bottom_sheet.dart';
import 'accessibility_scope.dart';
import 'big_cursor_overlay.dart';
import 'reading_guide_overlay.dart';

/// The root accessibility wrapper widget.
///
/// Wraps the application tree with accessibility modifications (text scaling, contrast,
/// animations, saturation, color filters), platform overlays (reading guide, big cursor),
/// and an optional floating action button to open accessibility preferences.
class AccessibilityWidget extends StatefulWidget {
  const AccessibilityWidget({
    required this.child,
    this.fabAlignment = Alignment.bottomRight,
    this.fabMargin = const EdgeInsets.all(16.0),
    this.showFloatingActionButton = true,
    this.controller,
    this.theme,
    this.fabIcon,
    super.key,
  });

  /// The child application widget tree.
  final Widget child;

  /// Optional accessibility controller. If not provided, a default one is instantiated.
  final AccessibilityController? controller;

  /// Optional theme configuration for the accessibility UI.
  final AccessibilityWidgetTheme? theme;

  /// Whether to display the floating accessibility preferences button.
  final bool showFloatingActionButton;

  /// Optional icon for the floating button. Overrides theme default if specified.
  final IconData? fabIcon;

  /// Screen alignment for the floating button.
  final Alignment fabAlignment;

  /// Padding / margin around the floating button.
  final EdgeInsets fabMargin;

  @override
  State<AccessibilityWidget> createState() => _AccessibilityWidgetState();
}

class _AccessibilityWidgetState extends State<AccessibilityWidget> {
  late AccessibilityController _controller;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = AccessibilityController();
      _isInternalController = true;
      _controller.restore();
    }
  }

  @override
  void didUpdateWidget(covariant AccessibilityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (_isInternalController) {
        _controller.dispose();
      }
      if (widget.controller != null) {
        _controller = widget.controller!;
        _isInternalController = false;
      } else {
        _controller = AccessibilityController();
        _isInternalController = true;
        _controller.restore();
      }
    }
  }

  @override
  void dispose() {
    if (_isInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AccessibilityScope(
      controller: _controller,
      theme: widget.theme,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          final AccessibilitySettings settings = _controller.settings;
          final AccessibilityWidgetTheme resolvedTheme =
              widget.theme?.resolveWith(context) ??
                  const AccessibilityWidgetTheme().resolveWith(context);

          Widget content = widget.child;

          // 1. Dyslexia / Spacing / Text Styling & Font adjustments via DefaultTextStyle
          if (settings.lineSpacing != 1.0 ||
              settings.letterSpacing != 0.0 ||
              settings.boldText ||
              settings.dyslexiaFont) {
            content = DefaultTextStyle.merge(
              style: TextStyle(
                fontWeight: settings.boldText ? FontWeight.bold : null,
                letterSpacing: settings.letterSpacing != 0.0
                    ? settings.letterSpacing
                    : null,
                height:
                    settings.lineSpacing != 1.0 ? settings.lineSpacing : null,
                fontFamily: settings.dyslexiaFont ? 'Andika' : null,
                fontFamilyFallback: settings.dyslexiaFont
                    ? const <String>[
                        'packages/accessibility_widget/Andika',
                        'Andika',
                        'monospace',
                        'sans-serif'
                      ]
                    : null,
              ),
              child: content,
            );
          }

          // 2. High Contrast / Invert Colors / Saturation Filters
          if (settings.invertColors) {
            content = ColorFiltered(
              colorFilter: const ColorFilter.matrix(<double>[
                -1,
                0,
                0,
                0,
                255,
                0,
                -1,
                0,
                0,
                255,
                0,
                0,
                -1,
                0,
                255,
                0,
                0,
                0,
                1,
                0,
              ]),
              child: content,
            );
          }

          if (settings.saturation != 1.0) {
            final double s = settings.saturation;
            const double lumR = 0.3086;
            const double lumG = 0.6094;
            const double lumB = 0.0820;
            final double sr = (1.0 - s) * lumR;
            final double sg = (1.0 - s) * lumG;
            final double sb = (1.0 - s) * lumB;

            content = ColorFiltered(
              colorFilter: ColorFilter.matrix(<double>[
                sr + s,
                sg,
                sb,
                0,
                0,
                sr,
                sg + s,
                sb,
                0,
                0,
                sr,
                sg,
                sb + s,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
              ]),
              child: content,
            );
          }

          // 3. Platform Overlays: Reading Guide & Big Cursor
          if (settings.readingGuide) {
            content = ReadingGuideOverlay(
              guideColor: resolvedTheme.accentColor,
              child: content,
            );
          }

          if (settings.bigCursor) {
            content = BigCursorOverlay(
              child: content,
            );
          }

          // 4. MediaQuery Overrides (textScaler, platformBrightness, boldText, animations)
          final MediaQueryData ambientMedia = MediaQuery.maybeOf(context) ??
              MediaQueryData.fromView(View.of(context));

          final Brightness effectiveBrightness = settings.darkMode != null
              ? (settings.darkMode! ? Brightness.dark : Brightness.light)
              : ambientMedia.platformBrightness;

          final MediaQueryData modifiedMedia = ambientMedia.copyWith(
            textScaler: TextScaler.linear(settings.textScale),
            boldText: settings.boldText,
            disableAnimations: settings.stopAnimations,
            platformBrightness: effectiveBrightness,
            highContrast: settings.highContrast,
          );

          final ThemeData ambientTheme = Theme.of(context);
          if (settings.darkMode != null &&
              ambientTheme.brightness != effectiveBrightness) {
            final ColorScheme newColorScheme = ColorScheme.fromSeed(
              seedColor: ambientTheme.colorScheme.primary,
              brightness: effectiveBrightness,
            );
            content = Theme(
              data: ThemeData(
                useMaterial3: ambientTheme.useMaterial3,
                brightness: effectiveBrightness,
                colorScheme: newColorScheme,
              ),
              child: content,
            );
          }

          content = MediaQuery(
            data: modifiedMedia,
            child: content,
          );

          // 5. Floating Action Button Entry Point
          if (widget.showFloatingActionButton) {
            final IconData effectiveFabIcon =
                widget.fabIcon ?? resolvedTheme.fabIcon;

            content = Stack(
              children: <Widget>[
                content,
                SafeArea(
                  child: Align(
                    alignment: widget.fabAlignment,
                    child: Padding(
                      padding: widget.fabMargin,
                      child: FloatingActionButton(
                        heroTag: 'accessibility_widget_fab',
                        shape: resolvedTheme.fabShape ?? const CircleBorder(),
                        backgroundColor: resolvedTheme.fabBackgroundColor,
                        foregroundColor: resolvedTheme.fabForegroundColor,
                        tooltip: 'Accessibility preferences',
                        onPressed: () => AccessibilityBottomSheet.show(
                          context,
                          alignment: widget.fabAlignment,
                          margin: widget.fabMargin,
                        ),
                        child: Icon(effectiveFabIcon),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return content;
        },
      ),
    );
  }
}

/// Alias for [AccessibilityWidget].
typedef AccessibilityOverlay = AccessibilityWidget;

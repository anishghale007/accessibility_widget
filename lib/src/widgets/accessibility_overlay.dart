import 'package:flutter/material.dart';
import '../controller/accessibility_controller.dart';
import '../models/accessibility_settings.dart';
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
    super.key,
  });

  /// The child application widget tree.
  final Widget child;

  @override
  State<AccessibilityWidget> createState() => _AccessibilityWidgetState();
}

class _AccessibilityWidgetState extends State<AccessibilityWidget> {
  late final AccessibilityController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AccessibilityController();
    _controller.restore();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AccessibilityScope(
      controller: _controller,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          final AccessibilitySettings settings = _controller.settings;
          final ThemeData ambientTheme = Theme.of(context);

          Widget content = widget.child;

          // 1. Text & Typography transformations (Dyslexia Font, Line Spacing, Letter Spacing, Bold)
          final TextStyle baseOverrideStyle = TextStyle(
            fontWeight: settings.boldText ? FontWeight.bold : null,
            letterSpacing:
                settings.letterSpacing != 0.0 ? settings.letterSpacing : null,
            height: settings.lineSpacing != 1.0 ? settings.lineSpacing : null,
            fontFamily: settings.dyslexiaFont
                ? 'packages/accessibility_widget/Andika'
                : null,
            fontFamilyFallback: settings.dyslexiaFont
                ? const <String>[
                    'packages/accessibility_widget/Andika',
                    'Andika',
                    'monospace',
                    'sans-serif'
                  ]
                : null,
          );

          if (settings.lineSpacing != 1.0 ||
              settings.letterSpacing != 0.0 ||
              settings.boldText ||
              settings.dyslexiaFont) {
            content = DefaultTextStyle.merge(
              style: baseOverrideStyle,
              child: content,
            );
          }

          // 2. Color Inversion Filter
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

          // 3. Saturation Filter
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

          // 4. Platform Overlays: Reading Guide & Big Cursor
          if (settings.readingGuide) {
            content = ReadingGuideOverlay(
              guideColor: ambientTheme.colorScheme.primary,
              child: content,
            );
          }

          if (settings.bigCursor) {
            content = BigCursorOverlay(
              child: content,
            );
          }

          // 5. Theme & Typography injection
          final MediaQueryData ambientMedia = MediaQuery.maybeOf(context) ??
              MediaQueryData.fromView(View.of(context));

          final Brightness effectiveBrightness = settings.darkMode != null
              ? (settings.darkMode! ? Brightness.dark : Brightness.light)
              : ambientMedia.platformBrightness;

          final bool isDark = effectiveBrightness == Brightness.dark;

          // Baseline theme matching effective brightness (ensuring proper black/white text colors)
          final ThemeData baselineTheme = (isDark
                  ? ThemeData.dark(useMaterial3: ambientTheme.useMaterial3)
                  : ThemeData.light(useMaterial3: ambientTheme.useMaterial3))
              .copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: ambientTheme.colorScheme.primary,
              brightness: effectiveBrightness,
            ),
          );

          ColorScheme effectiveColorScheme = baselineTheme.colorScheme;
          if (settings.highContrast) {
            effectiveColorScheme = isDark
                ? ColorScheme.highContrastDark().copyWith(
                    primary: const Color(0xFFFFD600),
                    onPrimary: Colors.black,
                    secondary: const Color(0xFF00E5FF),
                    onSecondary: Colors.black,
                    surface: Colors.black,
                    onSurface: Colors.white,
                    outline: Colors.white,
                  )
                : ColorScheme.highContrastLight().copyWith(
                    primary: const Color(0xFF002B7F),
                    onPrimary: Colors.white,
                    secondary: const Color(0xFF004D40),
                    onSecondary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black,
                    outline: Colors.black,
                  );
          } else if (settings.darkMode == null &&
              ambientTheme.brightness == effectiveBrightness) {
            effectiveColorScheme = ambientTheme.colorScheme;
          }

          // Use the textTheme of the matching brightness to ensure text colors are never inverted
          final TextTheme baseTextTheme = (settings.darkMode != null &&
                  settings.darkMode !=
                      (ambientTheme.brightness == Brightness.dark))
              ? baselineTheme.textTheme
              : ambientTheme.textTheme;

          // Build modified typography for ThemeData
          TextStyle transformStyle(TextStyle? base) {
            if (base == null) {
              return baseOverrideStyle;
            }
            return base.copyWith(
              fontFamily: settings.dyslexiaFont
                  ? 'packages/accessibility_widget/Andika'
                  : base.fontFamily,
              fontFamilyFallback: settings.dyslexiaFont
                  ? const <String>[
                      'packages/accessibility_widget/Andika',
                      'Andika',
                      'monospace',
                      'sans-serif'
                    ]
                  : base.fontFamilyFallback,
              fontWeight: settings.boldText ? FontWeight.bold : base.fontWeight,
              letterSpacing: settings.letterSpacing != 0.0
                  ? ((base.letterSpacing ?? 0.0) + settings.letterSpacing)
                  : base.letterSpacing,
              height: settings.lineSpacing != 1.0
                  ? ((base.height ?? 1.25) * settings.lineSpacing)
                  : base.height,
            );
          }

          TextTheme modifiedTextTheme = baseTextTheme;
          if (settings.dyslexiaFont ||
              settings.boldText ||
              settings.letterSpacing != 0.0 ||
              settings.lineSpacing != 1.0) {
            modifiedTextTheme = TextTheme(
              displayLarge: transformStyle(modifiedTextTheme.displayLarge),
              displayMedium: transformStyle(modifiedTextTheme.displayMedium),
              displaySmall: transformStyle(modifiedTextTheme.displaySmall),
              headlineLarge: transformStyle(modifiedTextTheme.headlineLarge),
              headlineMedium: transformStyle(modifiedTextTheme.headlineMedium),
              headlineSmall: transformStyle(modifiedTextTheme.headlineSmall),
              titleLarge: transformStyle(modifiedTextTheme.titleLarge),
              titleMedium: transformStyle(modifiedTextTheme.titleMedium),
              titleSmall: transformStyle(modifiedTextTheme.titleSmall),
              bodyLarge: transformStyle(modifiedTextTheme.bodyLarge),
              bodyMedium: transformStyle(modifiedTextTheme.bodyMedium),
              bodySmall: transformStyle(modifiedTextTheme.bodySmall),
              labelLarge: transformStyle(modifiedTextTheme.labelLarge),
              labelMedium: transformStyle(modifiedTextTheme.labelMedium),
              labelSmall: transformStyle(modifiedTextTheme.labelSmall),
            );
          }

          final ThemeData modifiedTheme = ambientTheme.copyWith(
            brightness: effectiveBrightness,
            colorScheme: effectiveColorScheme,
            textTheme: modifiedTextTheme,
            scaffoldBackgroundColor: settings.highContrast
                ? (isDark ? Colors.black : Colors.white)
                : (settings.darkMode != null
                    ? (isDark
                        ? const Color(0xFF121212)
                        : const Color(0xFFFAFAFA))
                    : ambientTheme.scaffoldBackgroundColor),
            cardTheme: settings.highContrast
                ? ambientTheme.cardTheme.copyWith(
                    color: isDark ? const Color(0xFF121212) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isDark ? Colors.white : Colors.black,
                        width: 2.0,
                      ),
                    ),
                  )
                : ambientTheme.cardTheme,
            dividerTheme: settings.highContrast
                ? ambientTheme.dividerTheme.copyWith(
                    color: isDark ? Colors.white70 : Colors.black87,
                    thickness: 1.5,
                  )
                : ambientTheme.dividerTheme,
          );

          content = Theme(
            data: modifiedTheme,
            child: content,
          );

          // 6. MediaQuery Overrides
          final MediaQueryData modifiedMedia = ambientMedia.copyWith(
            textScaler: TextScaler.linear(settings.textScale),
            boldText: settings.boldText,
            disableAnimations: settings.stopAnimations,
            platformBrightness: effectiveBrightness,
            highContrast: settings.highContrast,
          );

          content = MediaQuery(
            data: modifiedMedia,
            child: content,
          );

          return content;
        },
      ),
    );
  }
}

/// Alias for [AccessibilityWidget].
typedef AccessibilityOverlay = AccessibilityWidget;

import 'package:flutter/material.dart';
import '../controller/accessibility_controller.dart';
import '../models/accessibility_settings.dart';
import 'accessibility_panel_content.dart';
import 'accessibility_scope.dart';

/// Full-page screen entry point for accessibility settings.
///
/// Can be pushed via [Navigator] from an app's existing settings menu or navigation tree:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (_) => const AccessibilitySettingsPage()),
/// );
/// ```
class AccessibilitySettingsPage extends StatelessWidget {
  const AccessibilitySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AccessibilityScope? ancestorScope =
        AccessibilityScope.maybeOf(context);

    Widget buildPage(AccessibilityScope scope, BuildContext pageContext) {
      final AccessibilitySettings settings = scope.settings;
      final ThemeData ambientTheme = Theme.of(pageContext);
      final MediaQueryData ambientMedia = MediaQuery.maybeOf(pageContext) ??
          MediaQueryData.fromView(View.of(pageContext));

      final Brightness effectiveBrightness = settings.darkMode != null
          ? (settings.darkMode! ? Brightness.dark : Brightness.light)
          : ambientMedia.platformBrightness;

      final bool isDark = effectiveBrightness == Brightness.dark;

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

      final TextTheme baseTextTheme = (settings.darkMode != null &&
              settings.darkMode != (ambientTheme.brightness == Brightness.dark))
          ? baselineTheme.textTheme
          : ambientTheme.textTheme;

      final ThemeData pageTheme = ambientTheme.copyWith(
        brightness: effectiveBrightness,
        colorScheme: effectiveColorScheme,
        textTheme: baseTextTheme,
        scaffoldBackgroundColor:
            isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
      );

      return Theme(
        data: pageTheme,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Accessibility'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.restore),
                tooltip: 'Reset to defaults',
                onPressed: () => scope.controller.reset(),
              ),
            ],
          ),
          body: const SafeArea(
            child: AccessibilityPanelContent(),
          ),
        ),
      );
    }

    if (ancestorScope != null) {
      return buildPage(ancestorScope, context);
    }

    // Fallback if pushed without an ancestor AccessibilityScope
    final AccessibilityController fallbackController =
        AccessibilityController();
    fallbackController.restore();

    return AccessibilityScope(
      controller: fallbackController,
      child: Builder(
        builder: (BuildContext scopedContext) {
          final AccessibilityScope scope = AccessibilityScope.of(scopedContext);
          return buildPage(scope, scopedContext);
        },
      ),
    );
  }
}

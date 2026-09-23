import 'package:flutter/material.dart';
import '../controller/accessibility_controller.dart';
import '../theme/accessibility_widget_theme.dart';
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
  const AccessibilitySettingsPage({
    super.key,
    this.controller,
    this.theme,
  });

  /// Optional controller instance if opened outside an ancestor [AccessibilityScope].
  final AccessibilityController? controller;

  /// Optional theme instance if opened outside an ancestor [AccessibilityScope].
  final AccessibilityWidgetTheme? theme;

  @override
  Widget build(BuildContext context) {
    final AccessibilityScope? ancestorScope =
        AccessibilityScope.maybeOf(context);
    final AccessibilityController effectiveController =
        controller ?? ancestorScope?.controller ?? AccessibilityController();
    final AccessibilityWidgetTheme? effectiveTheme =
        theme ?? ancestorScope?.theme;

    return AccessibilityScope(
      controller: effectiveController,
      theme: effectiveTheme,
      child: Builder(
        builder: (BuildContext scopedContext) {
          final AccessibilityScope scope = AccessibilityScope.of(scopedContext);
          final AccessibilityWidgetTheme resolvedTheme =
              scope.theme?.resolveWith(scopedContext) ??
                  const AccessibilityWidgetTheme().resolveWith(scopedContext);

          return Scaffold(
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
            backgroundColor: resolvedTheme.panelBackgroundColor,
            body: const SafeArea(
              child: AccessibilityPanelContent(),
            ),
          );
        },
      ),
    );
  }
}

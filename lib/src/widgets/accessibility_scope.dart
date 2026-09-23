import 'package:flutter/widgets.dart';
import '../controller/accessibility_controller.dart';
import '../models/accessibility_settings.dart';
import '../theme/accessibility_widget_theme.dart';

/// Inherited widget that provides the [AccessibilityController], current [AccessibilitySettings],
/// and optional [AccessibilityWidgetTheme] down the widget tree.
class AccessibilityScope extends InheritedNotifier<AccessibilityController> {
  const AccessibilityScope({
    super.key,
    required AccessibilityController controller,
    required super.child,
    this.theme,
  }) : super(notifier: controller);

  /// Custom visual theme for the accessibility controls and overlays.
  final AccessibilityWidgetTheme? theme;

  /// The active [AccessibilityController] from this scope.
  AccessibilityController get controller => notifier!;

  /// The active [AccessibilitySettings] snapshot.
  AccessibilitySettings get settings => notifier!.settings;

  /// Obtains the nearest [AccessibilityScope] in the widget tree.
  /// Throws if no [AccessibilityScope] ancestor is found.
  static AccessibilityScope of(BuildContext context) {
    final AccessibilityScope? scope = maybeOf(context);
    assert(scope != null, 'No AccessibilityScope found in context');
    return scope!;
  }

  /// Obtains the nearest [AccessibilityScope] in the widget tree, or null if none is found.
  static AccessibilityScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AccessibilityScope>();
  }

  /// Obtains the active [AccessibilityController] without registering context for rebuilds.
  static AccessibilityController controllerOf(BuildContext context) {
    final InheritedElement? element =
        context.getElementForInheritedWidgetOfExactType<AccessibilityScope>();
    final AccessibilityScope? scope = element?.widget as AccessibilityScope?;
    assert(scope != null, 'No AccessibilityScope found in context');
    return scope!.controller;
  }
}

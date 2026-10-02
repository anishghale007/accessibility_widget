import 'package:flutter/material.dart';
import 'accessibility_scope.dart';

/// An accessible animation wrapper widget that respects the [AccessibilitySettings.stopAnimations]
/// preference and system [MediaQueryData.disableAnimations] setting.
///
/// When reduced motion / stop animations is active, this widget can either swap to a static
/// [fallback] widget, automatically stop an optional [AnimationController], or provide a reactive
/// [builder] callback.
///
/// ### Example 1: Basic with fallback
/// ```dart
/// AccessibleAnimation(
///   fallback: const StaticBanner(),
///   child: const RotatingBannerAnimation(),
/// )
/// ```
///
/// ### Example 2: With AnimationController auto-management
/// ```dart
/// AccessibleAnimation(
///   controller: _animationController,
///   child: RotationTransition(
///     turns: _animationController,
///     child: const Icon(Icons.sync),
///   ),
/// )
/// ```
///
/// ### Example 3: Builder pattern
/// ```dart
/// AccessibleAnimation.builder(
///   builder: (BuildContext context, bool isAnimating, Widget? child) {
///     return isAnimating
///         ? SpinningWidget(child: child)
///         : child!;
///   },
///   child: const Text('Content'),
/// )
/// ```
class AccessibleAnimation extends StatefulWidget {
  /// Creates an accessible animation widget that conditionally displays [child]
  /// or [fallback] based on active animation/motion preferences.
  const AccessibleAnimation({
    required this.child,
    this.fallback,
    this.controller,
    super.key,
  }) : builder = null;

  /// Creates an accessible animation widget using a dynamic [builder] function.
  const AccessibleAnimation.builder({
    required this.builder,
    this.child,
    this.controller,
    super.key,
  }) : fallback = null;

  /// The animated widget tree to render when animations are enabled.
  final Widget? child;

  /// Optional static fallback widget to render when animations are disabled.
  final Widget? fallback;

  /// Optional [AnimationController] to automatically pause when animations are disabled.
  final AnimationController? controller;

  /// Optional builder function receiving `(context, isAnimating, child)`.
  final Widget Function(BuildContext context, bool isAnimating, Widget? child)? builder;

  /// Checks whether animations and motion are currently enabled in the given [BuildContext].
  static bool areAnimationsEnabled(BuildContext context) {
    final bool stopAnimations =
        AccessibilityScope.maybeOf(context)?.settings.stopAnimations ?? false;
    final bool disableMediaAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return !stopAnimations && !disableMediaAnimations;
  }

  /// Checks whether reduced motion is active in the given [BuildContext].
  static bool isReducedMotion(BuildContext context) =>
      !areAnimationsEnabled(context);

  @override
  State<AccessibleAnimation> createState() => _AccessibleAnimationState();
}

class _AccessibleAnimationState extends State<AccessibleAnimation> {
  bool _wasAnimating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _handleControllerMotionState();
  }

  @override
  void didUpdateWidget(covariant AccessibleAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _handleControllerMotionState();
    }
  }

  void _handleControllerMotionState() {
    final AnimationController? ctrl = widget.controller;
    if (ctrl == null) return;

    final bool isEnabled = AccessibleAnimation.areAnimationsEnabled(context);
    if (!isEnabled) {
      if (ctrl.isAnimating) {
        _wasAnimating = true;
        ctrl.stop();
      }
    } else if (_wasAnimating) {
      _wasAnimating = false;
      ctrl.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isAnimating = AccessibleAnimation.areAnimationsEnabled(context);

    if (widget.builder != null) {
      return widget.builder!(context, isAnimating, widget.child);
    }

    if (!isAnimating && widget.fallback != null) {
      return widget.fallback!;
    }

    return widget.child ?? const SizedBox.shrink();
  }
}

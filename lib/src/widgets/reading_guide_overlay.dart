import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/platform.dart';

/// An accessibility overlay widget that dims the entire screen except for a
/// focused horizontal spotlight band around the content/line currently being read.
///
/// Users can drag the grip handle on the right edge of the spotlight band
/// up and down to track their reading position smoothly.
class ReadingGuideOverlay extends StatefulWidget {
  const ReadingGuideOverlay({
    super.key,
    required this.child,
    this.platform = PlatformInfo.current,
    this.guideHeight = 72.0,
    this.guideColor,
    this.overlayColor,
  });

  /// The underlying app widget tree.
  final Widget child;

  /// Platform detector to enable platform-specific branching and testing.
  final PlatformInfo platform;

  /// Height / thickness of the clear reading spotlight band.
  final double guideHeight;

  /// Custom color / tint for the reading guide boundary borders and grip handle.
  final Color? guideColor;

  /// Custom dimming mask color for content outside the reading band.
  final Color? overlayColor;

  @override
  State<ReadingGuideOverlay> createState() => _ReadingGuideOverlayState();
}

class _ReadingGuideOverlayState extends State<ReadingGuideOverlay> {
  double? _guideY;
  bool _isDragging = false;

  void _onHover(PointerEvent event) {
    if (widget.platform.isWeb && !_isDragging) {
      setState(() {
        _guideY = event.position.dy - (widget.guideHeight / 2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color effectiveAccentColor =
        widget.guideColor ?? theme.colorScheme.primary;
    final Color maskColor =
        widget.overlayColor ?? Colors.black.withValues(alpha: 0.8);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxHeight = constraints.maxHeight;
        final double maxGuideY =
            (maxHeight - widget.guideHeight).clamp(0.0, maxHeight);

        // Initialize position to ~30% down the screen if not set or clamped
        final double currentY =
            (_guideY ?? (maxHeight * 0.3)).clamp(0.0, maxGuideY);

        Widget stack = Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // Underlying content (scrolls and receives pointer events normally)
            widget.child,

            // Top Dimming Mask
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: currentY,
              child: IgnorePointer(
                child: ColoredBox(color: maskColor),
              ),
            ),

            // Bottom Dimming Mask
            Positioned(
              top: currentY + widget.guideHeight,
              left: 0,
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                child: ColoredBox(color: maskColor),
              ),
            ),

            // Reading Spotlight Band Outline & Draggable Grip Handle
            Stack(
              children: <Widget>[
                // Visual guideline borders (top & bottom)
                IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: effectiveAccentColor.withValues(alpha: 0.8),
                          width: 1.5,
                        ),
                        bottom: BorderSide(
                          color: effectiveAccentColor.withValues(alpha: 0.8),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                // Compact, elegant draggable grip handle on the right edge
                if (!kIsWeb)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onVerticalDragStart: (_) {
                          setState(() => _isDragging = true);
                        },
                        onVerticalDragUpdate: (DragUpdateDetails details) {
                          setState(() {
                            _guideY = ((_guideY ?? currentY) + details.delta.dy)
                                .clamp(0.0, maxGuideY);
                          });
                        },
                        onVerticalDragEnd: (_) {
                          setState(() => _isDragging = false);
                        },
                        onVerticalDragCancel: () {
                          setState(() => _isDragging = false);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 24,
                          height: 40,
                          decoration: BoxDecoration(
                            color: effectiveAccentColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: effectiveAccentColor.withValues(
                                  alpha: 0.35,
                                ),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 3,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 1.0,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.unfold_more_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );

        if (widget.platform.isWeb) {
          return MouseRegion(
            onHover: _onHover,
            child: stack,
          );
        }

        return stack;
      },
    );
  }
}

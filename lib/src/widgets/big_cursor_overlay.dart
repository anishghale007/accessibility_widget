import 'package:flutter/material.dart';
import '../utils/platform.dart';

/// Web-only overlay that replaces the default browser cursor with an enlarged, high-visibility cursor follower.
class BigCursorOverlay extends StatefulWidget {
  const BigCursorOverlay({
    super.key,
    required this.child,
    this.platform = PlatformInfo.current,
    this.cursorSize = 36.0,
    this.cursorColor,
  });

  /// The child widget tree.
  final Widget child;

  /// Platform helper used for testing and web detection.
  final PlatformInfo platform;

  /// Size of the enlarged cursor icon.
  final double cursorSize;

  /// Color of the enlarged cursor icon.
  final Color? cursorColor;

  @override
  State<BigCursorOverlay> createState() => _BigCursorOverlayState();
}

class _BigCursorOverlayState extends State<BigCursorOverlay> {
  Offset? _cursorPosition;
  bool _isHovering = false;

  void _onHover(PointerEvent event) {
    setState(() {
      _cursorPosition = event.position;
      _isHovering = true;
    });
  }

  void _onExit(PointerEvent event) {
    setState(() {
      _isHovering = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.platform.isWeb) {
      return widget.child;
    }

    final ThemeData theme = Theme.of(context);
    final Color effectiveColor = widget.cursorColor ?? theme.colorScheme.primary;

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onHover: _onHover,
      onExit: _onExit,
      child: Stack(
        children: <Widget>[
          widget.child,
          if (_isHovering && _cursorPosition != null)
            Positioned(
              left: _cursorPosition!.dx,
              top: _cursorPosition!.dy,
              child: IgnorePointer(
                child: CustomPaint(
                  size: Size(widget.cursorSize, widget.cursorSize),
                  painter: _EnlargedCursorPainter(
                    color: effectiveColor,
                    strokeColor: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EnlargedCursorPainter extends CustomPainter {
  const _EnlargedCursorPainter({
    required this.color,
    required this.strokeColor,
  });

  final Color color;
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    // Draw classic pointer arrow
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.75, size.height * 0.65);
    path.lineTo(size.width * 0.45, size.height * 0.65);
    path.lineTo(size.width * 0.65, size.height * 0.95);
    path.lineTo(size.width * 0.45, size.height * 1.05);
    path.lineTo(size.width * 0.25, size.height * 0.75);
    path.lineTo(0, size.height * 0.95);
    path.close();

    // Fill
    final Paint fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // High contrast white outline
    final Paint strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _EnlargedCursorPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeColor != strokeColor;
  }
}

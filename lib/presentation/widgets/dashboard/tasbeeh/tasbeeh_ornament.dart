import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Quiet geometry that gives the dhikr surfaces a distinct visual identity.
class TasbeehOrnament extends StatelessWidget {
  const TasbeehOrnament({
    super.key,
    this.opacity = 0.12,
    this.color = Colors.white,
  });

  final double opacity;
  final Color color;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: CustomPaint(painter: _TasbeehOrnamentPainter(opacity, color)),
  );
}

class _TasbeehOrnamentPainter extends CustomPainter {
  const _TasbeehOrnamentPainter(this.opacity, this.color);

  final double opacity;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    _drawRosette(
      canvas,
      Offset(size.width * 0.9, size.height * 0.13),
      math.min(size.width, size.height) * 0.3,
      paint,
    );
    _drawRosette(
      canvas,
      Offset(size.width * 0.08, size.height * 0.9),
      math.min(size.width, size.height) * 0.23,
      paint,
    );
    for (final point in const [
      Offset(0.12, 0.12),
      Offset(0.2, 0.35),
      Offset(0.81, 0.39),
      Offset(0.68, 0.76),
      Offset(0.94, 0.68),
    ]) {
      final center = Offset(point.dx * size.width, point.dy * size.height);
      canvas.drawCircle(center, 2, Paint()..color = paint.color);
    }
  }

  void _drawRosette(Canvas canvas, Offset center, double radius, Paint paint) {
    for (final scale in [0.58, 0.82, 1.0]) {
      canvas.drawCircle(center, radius * scale, paint);
    }
    for (var index = 0; index < 8; index++) {
      final angle = index * math.pi / 4;
      final next = angle + math.pi / 4;
      final path = Path()
        ..moveTo(
          center.dx + radius * math.cos(angle),
          center.dy + radius * math.sin(angle),
        )
        ..lineTo(
          center.dx + radius * math.cos(next),
          center.dy + radius * math.sin(next),
        );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TasbeehOrnamentPainter oldDelegate) =>
      oldDelegate.opacity != opacity || oldDelegate.color != color;
}

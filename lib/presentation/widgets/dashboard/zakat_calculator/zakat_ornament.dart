import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A quiet geometric motif that stays behind the calculator's content.
class ZakatOrnament extends StatelessWidget {
  const ZakatOrnament({super.key, this.opacity = 1});

  final double opacity;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: CustomPaint(painter: _ZakatOrnamentPainter(opacity)),
  );
}

class _ZakatOrnamentPainter extends CustomPainter {
  const _ZakatOrnamentPainter(this.opacity);

  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width - 36, size.height * 0.38);
    final gold = Paint()
      ..color = const Color(0xFFE5C46F).withValues(alpha: 0.2 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final fine = Paint()
      ..color = Colors.white.withValues(alpha: 0.09 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (final radius in [86.0, 110.0, 150.0, 196.0]) {
      canvas.drawCircle(center, radius, radius == 110 ? gold : fine);
    }
    for (var rotation = 0; rotation < 2; rotation++) {
      final path = Path();
      for (var point = 0; point < 8; point++) {
        final angle =
            (point * math.pi / 4) - math.pi / 2 + rotation * math.pi / 8;
        final vertex = Offset(
          center.dx + 110 * math.cos(angle),
          center.dy + 110 * math.sin(angle),
        );
        if (point == 0) {
          path.moveTo(vertex.dx, vertex.dy);
        } else {
          path.lineTo(vertex.dx, vertex.dy);
        }
      }
      canvas.drawPath(path..close(), rotation == 0 ? gold : fine);
    }
    canvas.drawCircle(
      center,
      5,
      Paint()..color = const Color(0xFFE5C46F).withValues(alpha: 0.4 * opacity),
    );
  }

  @override
  bool shouldRepaint(covariant _ZakatOrnamentPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

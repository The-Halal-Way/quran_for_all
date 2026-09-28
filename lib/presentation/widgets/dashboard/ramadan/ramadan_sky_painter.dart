import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/my_colors.dart';

class RamadanSkyPainter extends CustomPainter {
  const RamadanSkyPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width - 48, size.height * 0.44);
    final ringPaint = Paint()
      ..color = MyColors.secondaryLight.withValues(alpha: 0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final radius in [76.0, 112.0, 156.0, 206.0]) {
      canvas.drawCircle(center, radius, ringPaint);
    }
    final crescent = Path.combine(
      PathOperation.difference,
      Path()..addOval(Rect.fromCircle(center: center, radius: 48)),
      Path()..addOval(
        Rect.fromCircle(center: center.translate(17, -9), radius: 43),
      ),
    );
    canvas.drawPath(
      crescent,
      Paint()..color = MyColors.secondaryLight.withValues(alpha: 0.27),
    );
    for (final star in [
      Offset(size.width * 0.14, size.height * 0.2),
      Offset(size.width * 0.52, size.height * 0.12),
      Offset(size.width * 0.8, size.height * 0.83),
      Offset(size.width * 0.3, size.height * 0.72),
    ]) {
      _drawStar(canvas, star);
    }
  }

  void _drawStar(Canvas canvas, Offset center) {
    final path = Path();
    for (var index = 0; index < 8; index++) {
      final angle = -math.pi / 2 + index * math.pi / 4;
      final radius = index.isEven ? 7.0 : 2.4;
      final point = center.translate(
        radius * math.cos(angle),
        radius * math.sin(angle),
      );
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(
      path..close(),
      Paint()..color = MyColors.secondaryLight.withValues(alpha: 0.42),
    );
  }

  @override
  bool shouldRepaint(covariant RamadanSkyPainter oldDelegate) => false;
}

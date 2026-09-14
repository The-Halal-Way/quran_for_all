import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/my_colors.dart';

class PrayerRosettePainter extends CustomPainter {
  const PrayerRosettePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.47;
    final stroke = Paint()
      ..color = MyColors.tertiaryLight.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final path = Path();
    for (var point = 0; point < 16; point++) {
      final pointRadius = point.isEven ? radius : radius * 0.79;
      final angle = -math.pi / 2 + point * math.pi / 8;
      final position =
          center + Offset(math.cos(angle), math.sin(angle)) * pointRadius;
      if (point == 0) {
        path.moveTo(position.dx, position.dy);
      } else {
        path.lineTo(position.dx, position.dy);
      }
    }
    canvas.drawPath(path..close(), stroke);
    canvas.drawCircle(center, radius * 0.9, stroke);
    for (var point = 0; point < 8; point++) {
      final angle = point * math.pi / 4;
      canvas.drawCircle(
        center + Offset(math.cos(angle), math.sin(angle)) * radius,
        1.8,
        Paint()..color = MyColors.secondaryLight.withValues(alpha: 0.8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant PrayerRosettePainter oldDelegate) => false;
}

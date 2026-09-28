import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/my_colors.dart';

class NeedHeroArt extends CustomPainter {
  const NeedHeroArt();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.83, size.height * 0.47);
    final line = Paint()
      ..color = MyColors.secondaryLight.withValues(alpha: 0.19)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final radius in [70.0, 105.0, 140.0, 175.0]) {
      canvas.drawCircle(center, radius, line);
    }
    for (var ring = 0; ring < 3; ring++) {
      final radius = 76.0 + ring * 35;
      for (var point = 0; point < 12; point++) {
        final angle = point * math.pi / 6;
        canvas.drawCircle(
          center.translate(math.cos(angle) * radius, math.sin(angle) * radius),
          2.1,
          Paint()..color = MyColors.secondaryLight.withValues(alpha: 0.33),
        );
      }
    }
    final star = Path();
    for (var point = 0; point < 16; point++) {
      final angle = point * math.pi / 8 - math.pi / 2;
      final radius = point.isEven ? 50.0 : 26.0;
      final offset = center.translate(
        math.cos(angle) * radius,
        math.sin(angle) * radius,
      );
      if (point == 0) {
        star.moveTo(offset.dx, offset.dy);
      } else {
        star.lineTo(offset.dx, offset.dy);
      }
    }
    canvas.drawPath(
      star..close(),
      Paint()..color = MyColors.secondaryLight.withValues(alpha: 0.11),
    );
  }

  @override
  bool shouldRepaint(covariant NeedHeroArt oldDelegate) => false;
}

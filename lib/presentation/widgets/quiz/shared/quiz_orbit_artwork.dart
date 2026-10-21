import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme_colors.dart';

/// A small static compass of six subjects. No assets, tickers, or data reads.
class QuizOrbitArtwork extends StatelessWidget {
  const QuizOrbitArtwork({super.key, this.size = 86});
  final double size;
  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(
      painter: const _OrbitPainter(),
      child: Center(
        child: Icon(
          Icons.auto_awesome_rounded,
          color: Colors.white,
          size: size * .31,
        ),
      ),
    ),
  );
}

class _OrbitPainter extends CustomPainter {
  const _OrbitPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(
      center,
      radius * .86,
      paint..color = Colors.white.withValues(alpha: .28),
    );
    canvas.drawCircle(
      center,
      radius * .63,
      paint..color = Colors.white.withValues(alpha: .12),
    );
    final hexagon = Path();
    for (var i = 0; i < 6; i++) {
      final angle = math.pi * i / 3 - math.pi / 2;
      final point =
          center + Offset(math.cos(angle), math.sin(angle)) * radius * .53;
      if (i == 0) {
        hexagon.moveTo(point.dx, point.dy);
      } else {
        hexagon.lineTo(point.dx, point.dy);
      }
      canvas.drawCircle(
        center + Offset(math.cos(angle), math.sin(angle)) * radius * .86,
        radius * .055,
        Paint()..color = i.isEven ? AppThemeColors.light.cyan : Colors.white,
      );
    }
    canvas.drawPath(
      hexagon..close(),
      Paint()..color = Colors.white.withValues(alpha: .16),
    );
  }

  @override
  bool shouldRepaint(_OrbitPainter oldDelegate) => false;
}

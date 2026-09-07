import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/my_colors.dart';

class PrayerHeroArtwork extends StatelessWidget {
  const PrayerHeroArtwork({super.key, required this.icon, required this.size});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: _PrayerRosettePainter()),
          ),
          Container(
            width: size * 0.56,
            height: size * 0.56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MyColors.primaryDark.withValues(alpha: 0.72),
              border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
              boxShadow: [
                BoxShadow(
                  color: MyColors.tertiary.withValues(alpha: 0.24),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: size * 0.25),
          ),
        ],
      ),
    );
  }
}

class _PrayerRosettePainter extends CustomPainter {
  const _PrayerRosettePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.45;
    final path = Path();

    for (var point = 0; point < 12; point++) {
      final pointRadius = point.isEven ? radius : radius * 0.72;
      final angle = -math.pi / 2 + point * math.pi / 6;
      final position = Offset(
        center.dx + math.cos(angle) * pointRadius,
        center.dy + math.sin(angle) * pointRadius,
      );
      if (point == 0) {
        path.moveTo(position.dx, position.dy);
      } else {
        path.lineTo(position.dx, position.dy);
      }
    }
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..color = MyColors.tertiaryLight.withValues(alpha: 0.28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1,
    );
    canvas.drawCircle(
      center,
      radius * 0.82,
      Paint()
        ..color = MyColors.secondaryLight.withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

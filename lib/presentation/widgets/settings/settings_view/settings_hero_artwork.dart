import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/my_colors.dart';

class SettingsHeroArtwork extends StatelessWidget {
  const SettingsHeroArtwork({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: _SettingsOrbitPainter()),
          ),
          Container(
            width: size * 0.54,
            height: size * 0.54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MyColors.primaryDark.withValues(alpha: 0.68),
              border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
              boxShadow: [
                BoxShadow(
                  color: MyColors.primaryLight.withValues(alpha: 0.28),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Icon(
              Icons.tune_rounded,
              color: Colors.white,
              size: size * 0.24,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsOrbitPainter extends CustomPainter {
  const _SettingsOrbitPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.39;
    final ringPaint = Paint()
      ..color = MyColors.tertiaryLight.withValues(alpha: 0.26)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    canvas.drawCircle(center, radius, ringPaint);

    for (var node = 0; node < 3; node++) {
      final angle = -math.pi / 2 + node * math.pi * 2 / 3;
      final position = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      canvas.drawCircle(
        position,
        size.shortestSide * 0.045,
        Paint()
          ..color = node.isEven
              ? MyColors.secondaryLight
              : MyColors.tertiaryLight,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

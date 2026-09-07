import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

class SunnahDuaHeroArtwork extends StatelessWidget {
  const SunnahDuaHeroArtwork({
    super.key,
    required this.arabicTitle,
    required this.size,
  });

  final String arabicTitle;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: _SunnahRosettePainter()),
          ),
          Container(
            width: size * 0.62,
            height: size * 0.62,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MyColors.primaryDark.withValues(alpha: 0.7),
              border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
              boxShadow: [
                BoxShadow(
                  color: MyColors.secondary.withValues(alpha: 0.24),
                  blurRadius: 26,
                ),
              ],
            ),
            child: Text(
              arabicTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTheme.amiri(
                context,
                fontSize: size * 0.15,
                fontWeight: AppTheme.weightBold,
                color: Colors.white,
                height: 1.05,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SunnahRosettePainter extends CustomPainter {
  const _SunnahRosettePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.46;
    final star = Path();

    for (var point = 0; point < 16; point++) {
      final pointRadius = point.isEven ? radius : radius * 0.7;
      final angle = -math.pi / 2 + point * math.pi / 8;
      final position = Offset(
        center.dx + math.cos(angle) * pointRadius,
        center.dy + math.sin(angle) * pointRadius,
      );
      if (point == 0) {
        star.moveTo(position.dx, position.dy);
      } else {
        star.lineTo(position.dx, position.dy);
      }
    }
    star.close();

    canvas.drawPath(
      star,
      Paint()
        ..color = MyColors.secondaryLight.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1,
    );
    canvas.drawCircle(
      center,
      radius * 0.8,
      Paint()
        ..color = MyColors.tertiaryLight.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

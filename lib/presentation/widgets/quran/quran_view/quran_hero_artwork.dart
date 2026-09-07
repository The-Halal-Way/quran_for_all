import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

class QuranHeroArtwork extends StatelessWidget {
  const QuranHeroArtwork({
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
          const Positioned.fill(child: CustomPaint(painter: _RosettePainter())),
          Container(
            width: size * 0.59,
            height: size * 0.59,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  MyColors.primaryLight.withValues(alpha: 0.95),
                  MyColors.primaryDark.withValues(alpha: 0.92),
                ],
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: MyColors.secondary.withValues(alpha: 0.26),
                  blurRadius: 28,
                  spreadRadius: 2,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              arabicTitle,
              maxLines: 1,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTheme.amiri(
                context,
                fontSize: size * 0.19,
                fontWeight: AppTheme.weightBold,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RosettePainter extends CustomPainter {
  const _RosettePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.shortestSide * 0.46;
    final innerRadius = outerRadius * 0.72;
    final star = Path();

    for (var point = 0; point < 16; point++) {
      final radius = point.isEven ? outerRadius : innerRadius;
      final angle = -math.pi / 2 + point * math.pi / 8;
      final position = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      point == 0
          ? star.moveTo(position.dx, position.dy)
          : star.lineTo(position.dx, position.dy);
    }
    star.close();

    canvas.drawPath(
      star,
      Paint()
        ..color = MyColors.secondaryLight.withValues(alpha: 0.32)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.15,
    );
    canvas.drawCircle(
      center,
      outerRadius * 0.82,
      Paint()
        ..color = MyColors.tertiaryLight.withValues(alpha: 0.24)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

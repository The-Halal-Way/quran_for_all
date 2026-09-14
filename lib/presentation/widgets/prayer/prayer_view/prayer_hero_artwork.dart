import 'package:flutter/material.dart';

import '../../../../core/theme/my_colors.dart';
import 'prayer_rosette_painter.dart';

class PrayerHeroArtwork extends StatelessWidget {
  const PrayerHeroArtwork({super.key, required this.icon, required this.size});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: const PrayerRosettePainter(),
        child: Center(
          child: Container(
            width: size * 0.58,
            height: size * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(size * 0.4),
                bottom: Radius.circular(size * 0.08),
              ),
              gradient: LinearGradient(
                colors: [
                  MyColors.tertiary.withValues(alpha: 0.24),
                  MyColors.primaryDark.withValues(alpha: 0.8),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              border: Border.all(
                color: MyColors.tertiaryLight.withValues(alpha: 0.6),
              ),
              boxShadow: [
                BoxShadow(
                  color: MyColors.tertiary.withValues(alpha: 0.12),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Icon(icon, color: MyColors.tertiaryLight, size: size * 0.3),
          ),
        ),
      ),
    );
  }
}

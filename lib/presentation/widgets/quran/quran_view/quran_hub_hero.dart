import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/my_colors.dart';
import 'quran_hero_artwork.dart';
import 'quran_hero_identity.dart';

class QuranHubHero extends StatelessWidget {
  const QuranHubHero({
    super.key,
    required this.title,
    required this.eyebrow,
    required this.arabicTitle,
  });

  final String title;
  final String eyebrow;
  final String arabicTitle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 680;
        final artworkSize = isCompact ? 132.0 : 172.0;

        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  MyColors.primaryDark,
                  MyColors.primary,
                  Color(0xFF34146B),
                ],
                stops: [0, 0.58, 1],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Stack(
              children: [
                const Positioned.fill(
                  child: CustomPaint(painter: _HeroLinework()),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? AppSpacing.lg : AppSpacing.xxxl,
                    vertical: isCompact ? AppSpacing.xl : AppSpacing.xxl,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: QuranHeroIdentity(
                          title: title,
                          eyebrow: eyebrow,
                        ),
                      ),
                      SizedBox(
                        width: isCompact ? AppSpacing.sm : AppSpacing.xl,
                      ),
                      QuranHeroArtwork(
                        arabicTitle: arabicTitle,
                        size: artworkSize,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeroLinework extends CustomPainter {
  const _HeroLinework();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.055)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final origin = Offset(size.width * 0.78, size.height * 0.5);

    for (final radius in <double>[70, 112, 154, 196]) {
      canvas.drawCircle(origin, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

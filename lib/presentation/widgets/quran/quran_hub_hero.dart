import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/my_colors.dart';
import '../../../data/models/quran/quran_hub_models.dart';
import 'quran_hub_stat_chip.dart';

class QuranHubHero extends StatelessWidget {
  const QuranHubHero({
    super.key,
    required this.title,
    required this.eyebrow,
    required this.arabicTitle,
    required this.body,
    required this.stats,
  });

  final String title;
  final String eyebrow;
  final String arabicTitle;
  final String body;
  final List<QuranHubStat> stats;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 680;

        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  MyColors.primaryDark,
                  MyColors.primary,
                  MyColors.primaryLight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                const Positioned.fill(child: CustomPaint(painter: _Pattern())),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    isCompact ? 14 : 18,
                    isCompact ? 14 : 18,
                    isCompact ? 14 : 18,
                    isCompact ? 14 : 18,
                  ),
                  child: isCompact
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _HeroCopy(
                                    title: title,
                                    eyebrow: eyebrow,
                                    body: body,
                                    text: text,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                _ArabicMedallion(
                                  arabicTitle: arabicTitle,
                                  compact: true,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _StatsWrap(stats: stats),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _HeroCopy(
                                    title: title,
                                    eyebrow: eyebrow,
                                    body: body,
                                    text: text,
                                  ),
                                  const SizedBox(height: 14),
                                  _StatsWrap(stats: stats),
                                ],
                              ),
                            ),
                            const SizedBox(width: 22),
                            _ArabicMedallion(arabicTitle: arabicTitle),
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

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({
    required this.title,
    required this.eyebrow,
    required this.body,
    required this.text,
  });

  final String title;
  final String eyebrow;
  final String body;
  final AppTypography text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: MyColors.tertiary.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(
              color: MyColors.tertiaryLight.withValues(alpha: 0.36),
            ),
          ),
          child: Text(
            eyebrow,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.labelMedium.copyWith(
              color: MyColors.tertiaryLight,
              fontWeight: AppTheme.weightBold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: text.headlineMedium.copyWith(
            color: Colors.white,
            fontWeight: AppTheme.weightBlack,
            height: 1.02,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: text.bodyMedium.copyWith(
            color: Colors.white.withValues(alpha: 0.78),
            height: 1.35,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _ArabicMedallion extends StatelessWidget {
  const _ArabicMedallion({required this.arabicTitle, this.compact = false});

  final String arabicTitle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final outerSize = compact ? 82.0 : 118.0;
    final diamondSize = compact ? 58.0 : 84.0;
    final circleSize = compact ? 64.0 : 94.0;
    final fontSize = compact ? 22.0 : 30.0;

    return SizedBox(
      width: outerSize,
      height: outerSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: diamondSize,
              height: diamondSize,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.24),
                  width: 1.2,
                ),
              ),
            ),
          ),
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MyColors.primaryDark.withValues(alpha: 0.34),
              border: Border.all(
                color: MyColors.secondaryLight.withValues(alpha: 0.34),
              ),
            ),
          ),
          Text(
            arabicTitle,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: text.dashboardWatermarkArabic.copyWith(
              color: Colors.white,
              fontSize: AppTheme.scaledFontSize(context, fontSize),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsWrap extends StatelessWidget {
  const _StatsWrap({required this.stats});

  final List<QuranHubStat> stats;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [for (final stat in stats) QuranHubStatChip(stat: stat)],
    );
  }
}

class _Pattern extends CustomPainter {
  const _Pattern();

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final accentPaint = Paint()
      ..color = MyColors.secondaryLight.withValues(alpha: 0.16)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (var x = -size.height; x < size.width; x += 46) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        linePaint,
      );
    }
    for (var x = 0.0; x < size.width + size.height; x += 72) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - size.height, size.height),
        linePaint,
      );
    }

    final path = Path()
      ..moveTo(size.width * 0.70, 0)
      ..lineTo(size.width, size.height * 0.36)
      ..lineTo(size.width * 0.84, size.height)
      ..lineTo(size.width * 0.56, size.height * 0.68)
      ..close();
    canvas.drawPath(path, accentPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

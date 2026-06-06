import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_shadows.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/dashboard/ninety_nine_names.dart';
import 'package:quran_for_all/presentation/widgets/common/app_pill.dart';

import 'ninty_nine_names_localized.dart';

class NintyNineNamesHero extends StatelessWidget {
  const NintyNineNamesHero({
    super.key,
    required this.data,
    required this.language,
    required this.categoryCount,
    required this.isDark,
  });

  final NintyNineNames data;
  final AppLanguage language;
  final int categoryCount;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final metadata = data.metadata;
    final verse = metadata.quranVerse;

    return Container(
      margin: const EdgeInsets.only(top: 14, bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.hero(tint: MyColors.secondary),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                MyColors.primaryDark,
                MyColors.primaryLight,
                MyColors.secondary,
                MyColors.tertiaryDark,
              ],
              stops: [0, 0.44, 0.78, 1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: _HeroPatternPainter()),
              ),
              Positioned(
                right: -18,
                bottom: -36,
                child: Text(
                  'الله',
                  textDirection: ui.TextDirection.rtl,
                  style: AppTheme.amiri(
                    context,
                    fontSize: 132,
                    fontWeight: AppTheme.weightBold,
                    color: Colors.white.withValues(alpha: 0.07),
                    height: 1,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        AppPill.overlay(
                          icon: Icons.auto_awesome_rounded,
                          label: context.l10n.duahNintyNineSubtitle,
                        ),
                        AppPill.overlay(
                          icon: Icons.diamond_rounded,
                          label: context.l10n.duahNintyNineNamesCount(
                            metadata.totalNames,
                          ),
                        ),
                        AppPill.overlay(
                          icon: Icons.category_rounded,
                          label: context.l10n.duahNintyNineCategoryCount(
                            categoryCount,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      metadata.titleFor(language),
                      style: text.headlineMedium.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.weightBlack,
                        height: 1.08,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'أَسْمَاءُ اللهِ الْحُسْنَى',
                      textDirection: ui.TextDirection.rtl,
                      style: AppTheme.amiri(
                        context,
                        fontSize: 35,
                        fontWeight: AppTheme.weightBold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _VersePanel(
                      verse: verse,
                      language: language,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VersePanel extends StatelessWidget {
  const _VersePanel({
    required this.verse,
    required this.language,
    required this.isDark,
  });

  final QuranVerse verse;
  final AppLanguage language;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.15),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: Colors.white.withValues(alpha: 0.86),
                size: 15,
              ),
              const SizedBox(width: 7),
              Text(
                context.l10n.duahNintyNineVerseLabel,
                style: text.labelSmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontWeight: AppTheme.weightBold,
                ),
              ),
              const Spacer(),
              Text(
                '${verse.surahFor(language)} ${verse.verse}',
                style: text.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.weightBold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            verse.textFor(language),
            style: text.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.weightSemiBold,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    const step = 42.0;
    for (double x = 0; x < size.width + step; x += step) {
      for (double y = 0; y < size.height + step; y += step) {
        final center = Offset(x, y);
        final path = Path()
          ..moveTo(center.dx, center.dy - 9)
          ..lineTo(center.dx + 9, center.dy)
          ..lineTo(center.dx, center.dy + 9)
          ..lineTo(center.dx - 9, center.dy)
          ..close();
        canvas.drawPath(path, linePaint);
        canvas.drawCircle(center, 1.6, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

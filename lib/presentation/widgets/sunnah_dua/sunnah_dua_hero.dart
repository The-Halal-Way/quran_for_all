import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_gradients.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

class SunnahDuaHero extends StatelessWidget {
  const SunnahDuaHero({
    super.key,
    required this.totalCount,
    required this.sunnahCount,
    required this.duaCount,
    this.onBack,
  });

  final int totalCount;
  final int sunnahCount;
  final int duaCount;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xxl),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isDark ? AppGradients.splash : AppGradients.heroBanner,
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: CustomPaint(painter: _HeroPattern())),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (onBack != null) ...[
                              _HeroBackButton(onBack: onBack!),
                              const SizedBox(width: AppSpacing.sm),
                            ],
                            Flexible(
                              child: _HeroPill(
                                label: context.l10n.sunnahDuaHeroEyebrow,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          context.l10n.sunnahDuaTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleLarge.copyWith(
                            color: Colors.white,
                            fontWeight: AppTheme.weightBlack,
                            height: 1.08,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          context.l10n.sunnahDuaHeroBody,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.78),
                            fontWeight: AppTheme.weightSemiBold,
                            height: 1.35,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: [
                            _HeroStat(
                              value: '$totalCount',
                              label: context.l10n.sunnahDuaHeroStatGrid,
                            ),
                            _HeroStat(
                              value: '$sunnahCount',
                              label: context.l10n.sunnahDuaFilterSunnah,
                            ),
                            _HeroStat(
                              value: '$duaCount',
                              label: context.l10n.sunnahDuaFilterDua,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  _ArabicSeal(label: context.l10n.sunnahDuaHeroArabic),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroBackButton extends StatelessWidget {
  const _HeroBackButton({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onBack,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.14),
        foregroundColor: Colors.white,
        fixedSize: const Size(34, 34),
        minimumSize: const Size(34, 34),
        padding: EdgeInsets.zero,
      ),
      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 17),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: text.labelSmall.copyWith(
          color: MyColors.tertiaryLight,
          fontWeight: AppTheme.weightBlack,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: text.labelMedium.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.weightBlack,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: text.labelSmall.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: AppTheme.weightBold,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArabicSeal extends StatelessWidget {
  const _ArabicSeal({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return SizedBox(
      width: 78,
      height: 88,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
            ),
          ),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MyColors.primaryDark.withValues(alpha: 0.32),
              border: Border.all(
                color: MyColors.tertiaryLight.withValues(alpha: 0.44),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              label,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: text.dashboardWatermarkArabic.copyWith(
                color: Colors.white,
                fontSize: AppTheme.scaledFontSize(context, 20),
                height: 1.1,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPattern extends CustomPainter {
  const _HeroPattern();

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final diamondPaint = Paint()
      ..color = MyColors.tertiaryLight.withValues(alpha: 0.2)
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;

    for (var x = -size.height; x < size.width; x += 38) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        linePaint,
      );
    }

    for (var x = 28.0; x < size.width; x += 78) {
      for (var y = 24.0; y < size.height; y += 58) {
        final path = Path()
          ..moveTo(x, y - 5)
          ..lineTo(x + 5, y)
          ..lineTo(x, y + 5)
          ..lineTo(x - 5, y)
          ..close();
        canvas.drawPath(path, diamondPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

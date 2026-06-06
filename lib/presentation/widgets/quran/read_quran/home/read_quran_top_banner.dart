import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:lottie/lottie.dart';
import 'package:quran_for_all/core/theme/my_icons.dart';
import 'package:quran_for_all/core/theme/my_images.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_gradients.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/app_responsive.dart';
import '../../../common/app_gradient_banner.dart';
import '../../../common/app_pill.dart';
import '../../../common/common_painters.dart';

class ReadQuranTopBanner extends StatelessWidget {
  const ReadQuranTopBanner({
    super.key,
    required this.onSearchTap,
    required this.surahCount,
  });

  final VoidCallback onSearchTap;
  final int surahCount;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = AppResponsive.of(context);
    final topShapeWidth = responsive.pick(
      mobile: 128,
      tablet: 112,
      desktop: 136,
    );
    final topShapeHeight = responsive.pick(mobile: 52, tablet: 48, desktop: 54);
    final decorCircleSize = responsive.pick(
      mobile: 56,
      tablet: 50,
      desktop: 58,
    );
    final leadingShapeWidth = responsive.pick(
      mobile: 62,
      tablet: 56,
      desktop: 64,
    );
    final leadingShapeHeight = responsive.pick(
      mobile: 56,
      tablet: 52,
      desktop: 58,
    );
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 14, end: 0),
      builder: (context, offset, child) {
        return Transform.translate(offset: Offset(0, offset), child: child);
      },
      child: AppGradientBanner(
        gradient: AppGradients.heroBanner,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -18,
              right: -12,
              child: SizedBox(
                width: (size.width * 0.2).clamp(
                  topShapeWidth - 20,
                  topShapeWidth + 20,
                ),
                height: topShapeHeight,
                child: CustomPaint(
                  painter: UShapePainter(
                    backgroundColor: Colors.white.withValues(alpha: 0.16),
                    shadowColor: Colors.black.withValues(alpha: 0.12),
                    bumpWidth: 48,
                    bumpHeight: 14,
                    shadowBlurRadius: 5,
                    shadowOffset: const Offset(0, 2),
                  ),
                ),
              ),
            ),
            Positioned(
              left: -25,
              bottom: -30,
              child: Container(
                width: decorCircleSize,
                height: decorCircleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.14),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // top row with icon and title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: leadingShapeWidth,
                      height: leadingShapeHeight,
                      child: CustomPaint(
                        painter: YShapePainter(
                          backgroundColor: Colors.white.withValues(alpha: 0.18),
                          shadowColor: Colors.black.withValues(alpha: 0.12),
                          bumpWidth: 26,
                          bumpHeight: 9,
                          shadowBlurRadius: 5,
                        ),
                        child: Center(
                          child: Lottie.asset(MyImages.quranAnimated),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.readQuranBannerTitle,
                            style: AppTheme.text(context).titleLarge.copyWith(
                              color: Colors.white,
                              fontWeight: AppTheme.weightExtraBold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            context.l10n.readQuranBannerSubtitle,
                            style: AppTheme.text(context).bodyMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.90),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                // surah count and offline status
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    AppPill.overlay(
                      imgIcon: MyIcons.readIcon,
                      label: '$surahCount ${context.l10n.readQuranSurahsLabel}',
                    ),
                    AppPill.overlay(
                      icon: Icons.download_done_rounded,
                      label: context.l10n.readQuranOfflineReadyLabel,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                // search button
                FilledButton.icon(
                  onPressed: onSearchTap,
                  style: FilledButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    backgroundColor: Colors.white.withValues(alpha: 0.18),
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.34),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  icon: Image.asset(
                    MyIcons.searchIcon,
                    width: 20,
                    height: 20,
                    color: Colors.white,
                  ),
                  label: Text(context.l10n.readQuranBannerSearchButton),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

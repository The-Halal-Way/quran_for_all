import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:quran_for_all/core/theme/my_icons.dart';
import 'package:quran_for_all/core/theme/my_images.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../common/app_gradient_banner.dart';
import '../../common/app_pill.dart';
import '../../common/common_painters.dart';

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
                width: size.width * .2.w, //.clamp(110.0, 136.0),
                height: 52.h.clamp(46.0, 58.0),
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
                width: 56.w.clamp(48.0, 64.0),
                height: 56.w.clamp(48.0, 64.0),
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
                      width: 62.w.clamp(56.0, 70.0),
                      height: 56.h.clamp(50.0, 62.0),
                      child: CustomPaint(
                        painter: YShapePainter(
                          backgroundColor: Colors.white.withValues(alpha: 0.18),
                          shadowColor: Colors.black.withValues(alpha: 0.12),
                          bumpWidth: 26,
                          bumpHeight: 9,
                          shadowBlurRadius: 5,
                        ),
                        child: Center(
                          child: Lottie.asset(
                            MyImages.quranAnimated,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.readQuranText('Read. Reflect. Remember.'),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            context.readQuranText(
                              'Offline Quran with Bangla and English support.',
                            ),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
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
                      label: '$surahCount ${context.readQuranText('Surahs')}',
                    ),
                    AppPill.overlay(
                      icon: Icons.download_done_rounded,
                      label: context.readQuranText('Offline Ready'),
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
                  label: Text(context.readQuranText('Search Surah, Ayah, Juz')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

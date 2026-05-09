import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../common/app_gradient_banner.dart';
import '../../common/app_pill.dart';

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
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 14, end: 0),
      builder: (context, offset, child) {
        return Transform.translate(offset: Offset(0, offset), child: child);
      },
      child: AppGradientBanner(
        gradient: AppColors.heroBanner,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.readQuranText('Read. Reflect. Remember.'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.readQuranText(
                'Offline Quran with Bangla and English support.',
              ),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.88),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                AppPill.overlay(
                  icon: Icons.menu_book_rounded,
                  label: '$surahCount ${context.readQuranText('Surahs')}',
                ),
                AppPill.overlay(
                  icon: Icons.download_done_rounded,
                  label: context.readQuranText('Offline Ready'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton.icon(
              onPressed: onSearchTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.40)),
              ),
              icon: const Icon(Icons.search_rounded),
              label: Text(context.readQuranText('Search Surah, Ayah, Juz')),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_gradients.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../common/app_gradient_banner.dart';
import '../../../common/app_pill.dart';

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
        gradient: AppGradients.heroBanner,
        borderRadius: AppRadius.xl,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.26),
                    ),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: Colors.white,
                    size: 26,
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.text(context).bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.88),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onSearchTap,
                  tooltip: context.l10n.readQuranBannerSearchButton,
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white.withValues(alpha: 0.14),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.24),
                    ),
                  ),
                  icon: const Icon(CupertinoIcons.search, size: 20),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                AppPill.overlay(
                  icon: CupertinoIcons.book,
                  label: '$surahCount ${context.l10n.readQuranSurahsLabel}',
                ),
                AppPill.overlay(
                  icon: Icons.download_done_rounded,
                  label: context.l10n.readQuranOfflineReadyLabel,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../common/daily_tracker_progress_ring.dart';
import 'daily_tracker_stat.dart';
import 'daily_tracker_hero_artwork.dart';

class DailyTrackerHero extends StatelessWidget {
  const DailyTrackerHero({
    super.key,
    required this.completed,
    required this.total,
  });
  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final date = DateFormat.MMMEd(
      context.l10n.localeName,
    ).format(DateTime.now());
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            MyColors.primaryDark,
            MyColors.primary,
            MyColors.secondaryDark,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        border: Border.all(
          color: MyColors.secondaryLight.withValues(alpha: 0.3),
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(
            child: IgnorePointer(child: DailyTrackerHeroArtwork()),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: text.labelMedium.copyWith(
                    color: MyColors.tertiaryLight,
                    fontWeight: AppTheme.weightBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.dailyTrackerHeroTitle,
                            style: text.titleLarge.copyWith(
                              color: Colors.white,
                              fontWeight: AppTheme.weightExtraBold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            context.l10n.dailyTrackerHeroSubtitle,
                            style: text.bodySmall.copyWith(
                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (scale < 1.5) ...[
                      const SizedBox(width: AppSpacing.md),
                      DailyTrackerProgressRing(
                        completed: completed,
                        total: total,
                        size: 88,
                        onDark: true,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: DailyTrackerStat(
                        value: completed,
                        label: context.l10n.dailyTrackerDoneLabel,
                        icon: Icons.check_circle_outline_rounded,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: DailyTrackerStat(
                        value: total - completed,
                        label: context.l10n.dailyTrackerRemainingLabel,
                        icon: Icons.radio_button_unchecked_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../data/models/prayer/prayer_detail_models.dart';
import '../prayer_visuals.dart';
import 'prayer_hero_artwork.dart';
import 'prayer_time_source_badge.dart';

class PrayerFocusHero extends StatelessWidget {
  const PrayerFocusHero({
    super.key,
    required this.content,
    required this.time,
    required this.hasTimes,
  });

  final PrayerFocusContent content;
  final String time;
  final bool hasTimes;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        gradient: const LinearGradient(
          colors: [
            MyColors.primaryDark,
            MyColors.primary,
            MyColors.primaryLight,
          ],
          stops: [0, 0.55, 1],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        border: Border.all(
          color: MyColors.primaryLight.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withValues(alpha: 0.2),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrayerTimeSourceBadge(hasTimes: hasTimes),
                const SizedBox(height: AppSpacing.xl),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final showArtwork =
                        constraints.maxWidth >= 280 &&
                        MediaQuery.textScalerOf(context).scale(16) < 24;
                    return Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.prayerViewCurrentFocus,
                                style: text.labelMedium.copyWith(
                                  color: MyColors.tertiaryLight,
                                  fontWeight: AppTheme.weightBold,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                content.title,
                                style: text.displaySmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: AppTheme.weightExtraBold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (showArtwork) ...[
                          const SizedBox(width: AppSpacing.md),
                          ExcludeSemantics(
                            child: PrayerHeroArtwork(
                              icon: PrayerVisuals.iconFor(content.prayer),
                              size: constraints.maxWidth > 500 ? 128 : 96,
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  content.subtitle,
                  style: text.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.76),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  color: MyColors.tertiaryLight,
                  size: 22,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    time,
                    style: text.titleLarge.copyWith(
                      color: Colors.white,
                      fontWeight: AppTheme.weightBold,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
                LayoutBuilder(
                  builder: (context, constraints) {
                    final showArtwork =
                        constraints.maxWidth >= 300 &&
                        MediaQuery.textScalerOf(context).scale(16) <= 20;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PrayerTimeSourceBadge(hasTimes: hasTimes),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                context.l10n.prayerViewCurrentFocus,
                                style: text.labelMedium.copyWith(
                                  color: MyColors.tertiaryLight,
                                  fontWeight: AppTheme.weightBold,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                content.title,
                                style: text.titleLarge.copyWith(
                                  color: Colors.white,
                                  fontWeight: AppTheme.weightExtraBold,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (showArtwork) ...[
                          const SizedBox(width: AppSpacing.sm),
                          ExcludeSemantics(
                            child: PrayerHeroArtwork(
                              icon: PrayerVisuals.iconFor(content.prayer),
                              size: constraints.maxWidth > 500 ? 84 : 72,
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
                    color: Colors.white.withValues(alpha: 0.84),
                    height: 1.35,
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
                  size: 19,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    time,
                    style: text.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: AppTheme.weightBold,
                      height: 1.25,
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

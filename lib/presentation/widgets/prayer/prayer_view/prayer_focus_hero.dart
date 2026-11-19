import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../data/models/prayer/prayer_detail_models.dart';
import '../prayer_time_countdown.dart';
import '../prayer_visuals.dart';
import 'prayer_hero_artwork.dart';
import 'prayer_fasting_times_strip.dart';
import 'prayer_time_source_badge.dart';

class PrayerFocusHero extends StatelessWidget {
  const PrayerFocusHero({
    super.key,
    required this.content,
    required this.hasTimes,
    this.endsAtUtc,
    this.sehriEnd,
    this.sehriRange,
    this.iftarTime,
  });

  final PrayerFocusContent content;
  final bool hasTimes;
  final DateTime? endsAtUtc;
  final String? sehriEnd;
  final String? sehriRange;
  final String? iftarTime;

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
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final showAside =
                        constraints.maxWidth >= 300 &&
                        MediaQuery.textScalerOf(context).scale(16) <= 20;
                    final showCountdown = hasTimes && endsAtUtc != null;
                    final heading = Column(
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
                    );
                    final countdown = showCountdown
                        ? PrayerTimeCountdown(
                            endsAtUtc: endsAtUtc!,
                            color: MyColors.tertiaryLight,
                            prominent: true,
                          )
                        : null;

                    if (!showAside) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          heading,
                          if (countdown != null) ...[
                            const SizedBox(height: AppSpacing.sm),
                            countdown,
                          ],
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: heading),
                        const SizedBox(width: AppSpacing.sm),
                        if (countdown != null)
                          SizedBox(
                            width: constraints.maxWidth > 500 ? 162 : 142,
                            child: countdown,
                          )
                        else
                          ExcludeSemantics(
                            child: PrayerHeroArtwork(
                              icon: PrayerVisuals.iconFor(content.prayer),
                              size: constraints.maxWidth > 500 ? 84 : 72,
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
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
          if (hasTimes)
            PrayerFastingTimesStrip(
              sehriEnd: sehriEnd,
              sehriRange: sehriRange,
              iftarTime: iftarTime,
            ),
        ],
      ),
    );
  }
}

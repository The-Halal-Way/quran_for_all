import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

import 'prayer_visuals.dart';

// MARK: Prayer - Focus Hero
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
    final accent = PrayerVisuals.accentFor(content.prayer);
    final text = AppTheme.text(context);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyColors.primary,
            Color.lerp(MyColors.primaryLight, accent, 0.22)!,
            MyColors.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // MARK: Prayer - Hero Watermark
          Positioned(
            right: -14,
            bottom: -18,
            child: Icon(
              PrayerVisuals.iconFor(content.prayer),
              size: 120,
              color: Colors.white.withValues(alpha: 0.055),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // MARK: Prayer - Hero Title Block
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.16),
                        ),
                      ),
                      child: Icon(
                        PrayerVisuals.iconFor(content.prayer),
                        color: accent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            content.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.prayerHeroTitle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            content.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: text.prayerHeroSubtitle.copyWith(
                              color: Colors.white.withValues(alpha: 0.78),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                // MARK: Prayer - Hero Time Block
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.prayerViewHeroNextLabel,
                            style: text.prayerHeroLabel.copyWith(
                              color: Colors.white.withValues(alpha: 0.68),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            hasTimes
                                ? context.l10n.prayerViewLoadedFromLocation
                                : context.l10n.prayerViewTimeFallback,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.prayerHeroChip.copyWith(
                              color: Colors.white.withValues(alpha: 0.82),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          time,
                          style: text.prayerHeroTime.copyWith(
                            color: Colors.white,
                          ),
                        ),
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

import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../data/models/prayer/prayer_detail_models.dart';
import '../prayer_visuals.dart';
import 'prayer_hero_artwork.dart';

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
    final icon = PrayerVisuals.iconFor(content.prayer);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 680;

        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  MyColors.primaryDark,
                  MyColors.primary,
                  Color(0xFF164E59),
                ],
                stops: [0, 0.62, 1],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? AppSpacing.lg : AppSpacing.xxxl,
                vertical: compact ? AppSpacing.lg : AppSpacing.xxl,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.prayerViewCurrentFocus.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.labelSmall.copyWith(
                            color: MyColors.tertiaryLight,
                            fontWeight: AppTheme.weightBold,
                            letterSpacing: 1.05,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          content.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.headlineMedium.copyWith(
                            color: Colors.white,
                            fontWeight: AppTheme.weightBlack,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                time,
                                maxLines: 1,
                                style: text.displaySmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: AppTheme.weightExtraBold,
                                  height: 1,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            _TimeSourceBadge(hasTimes: hasTimes),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: compact ? AppSpacing.sm : AppSpacing.xl),
                  PrayerHeroArtwork(icon: icon, size: compact ? 112 : 148),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TimeSourceBadge extends StatelessWidget {
  const _TimeSourceBadge({required this.hasTimes});

  final bool hasTimes;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.11),
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        ),
        child: Text(
          hasTimes
              ? context.l10n.prayerViewLoadedFromLocation
              : context.l10n.prayerViewTimeFallback,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.text(context).labelSmall.copyWith(
            color: Colors.white.withValues(alpha: 0.76),
            fontWeight: AppTheme.weightBold,
          ),
        ),
      ),
    );
  }
}

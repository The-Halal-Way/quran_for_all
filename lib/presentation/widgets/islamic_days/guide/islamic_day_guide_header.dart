import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/islamic_days/islamic_day_occurrence.dart';
import '../../../models/islamic_day_presenter.dart';
import '../shared/islamic_day_badge.dart';
import '../shared/islamic_days_artwork.dart';

class IslamicDayGuideHeader extends StatelessWidget {
  const IslamicDayGuideHeader({super.key, required this.occurrence});
  final IslamicDayOccurrence occurrence;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final accent = islamicDayAccent(context, occurrence.event.category);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.alphaBlend(accent.withValues(alpha: .14), scheme.surface),
            scheme.surface,
          ],
        ),
        border: Border.all(color: accent.withValues(alpha: .2)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -35,
            top: -32,
            width: 220,
            height: 220,
            child: Opacity(
              opacity: .16,
              child: IslamicDaysArtwork(color: accent),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IslamicDayBadge(
                  label: islamicDayCategoryLabel(
                    l10n,
                    occurrence.event.category,
                  ),
                  icon: islamicDayIcon(occurrence.event.category),
                  color: accent,
                ),
                const SizedBox(height: 20),
                Text(
                  occurrence.event.title.resolve(l10n.localeName),
                  style: AppTheme.text(context).headlineMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    IslamicDayBadge(
                      label: islamicDayHijriLabel(l10n, occurrence),
                      icon: Icons.nightlight_round,
                      color: accent,
                    ),
                    IslamicDayBadge(
                      label: islamicDayGregorianLabel(l10n, occurrence.date),
                      icon: Icons.calendar_today_outlined,
                      color: scheme.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  occurrence.event.description.resolve(l10n.localeName),
                  style: AppTheme.text(
                    context,
                  ).bodyLarge.copyWith(height: 1.65),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.islamicDaysWhen,
                  style: AppTheme.text(
                    context,
                  ).labelLarge.copyWith(color: accent),
                ),
                const SizedBox(height: 6),
                Text(
                  islamicDayRuleLabel(l10n, occurrence.event.rule),
                  style: AppTheme.text(context).bodySmall.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/islamic_days/islamic_day.dart';
import '../../../../data/models/islamic_days/islamic_day_occurrence.dart';
import '../../../models/islamic_day_presenter.dart';
import '../shared/islamic_day_badge.dart';

class IslamicDayOccasionCard extends StatelessWidget {
  const IslamicDayOccasionCard({
    super.key,
    required this.occurrence,
    required this.onOpen,
    required this.onSave,
    required this.saved,
  });

  final IslamicDayOccurrence occurrence;
  final VoidCallback onOpen;
  final VoidCallback onSave;
  final bool saved;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final event = occurrence.event;
    final accent = occurrence.dayFasting == IslamicDayFasting.prohibited
        ? scheme.error
        : islamicDayAccent(context, event.category);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: scheme.surface,
        border: Border.all(color: accent.withValues(alpha: .2)),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: .035),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onOpen,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: accent.withValues(alpha: .11),
                      ),
                      child: Icon(
                        islamicDayIcon(event.category),
                        color: accent,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title.resolve(l10n.localeName),
                            style: AppTheme.text(context).titleMedium.copyWith(
                              fontWeight: FontWeight.w800,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            islamicDayGregorianLabel(l10n, occurrence.date),
                            style: AppTheme.text(context).bodySmall.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onSave,
                      tooltip: saved
                          ? l10n.islamicDaysUnsave
                          : l10n.islamicDaysSave,
                      icon: Icon(
                        saved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: saved ? accent : scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  event.description.resolve(l10n.localeName),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.text(context).bodyMedium.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    IslamicDayBadge(
                      label: islamicDayCategoryLabel(l10n, event.category),
                      icon: islamicDayIcon(event.category),
                      color: accent,
                    ),
                    IslamicDayBadge(
                      label: islamicDayHijriLabel(l10n, occurrence),
                      icon: Icons.nightlight_outlined,
                      color: scheme.primary,
                    ),
                    if (occurrence.dayFasting == IslamicDayFasting.prohibited)
                      IslamicDayBadge(
                        label: l10n.islamicDaysProhibited,
                        icon: Icons.no_food_outlined,
                        color: scheme.error,
                      ),
                    if (event.fasting == IslamicDayFasting.recommended &&
                        !occurrence.fastingSuppressed)
                      IslamicDayBadge(
                        label: l10n.islamicDaysRecommended,
                        icon: Icons.nightlight_round,
                        color: accent,
                      ),
                    if (event.fasting == IslamicDayFasting.obligatory)
                      IslamicDayBadge(
                        label: l10n.islamicDaysObligatory,
                        icon: Icons.nightlight_round,
                        color: accent,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.islamicDaysViewGuidance,
                        style: AppTheme.text(
                          context,
                        ).labelLarge.copyWith(color: accent),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accent.withValues(alpha: .08),
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: accent,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

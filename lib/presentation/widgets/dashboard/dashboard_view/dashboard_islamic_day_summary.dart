import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../../data/models/islamic_days/islamic_day_occurrence.dart';
import '../../../models/islamic_day_presenter.dart';
import '../../../views/islamic_days/islamic_days_view.dart';

class DashboardIslamicDaySummary extends StatelessWidget {
  const DashboardIslamicDaySummary({
    super.key,
    required this.entry,
    required this.todayCount,
    required this.isToday,
    required this.prohibited,
    required this.hasDetails,
    required this.accent,
  });

  final IslamicDayOccurrence? entry;
  final int todayCount;
  final bool isToday;
  final bool prohibited;
  final bool hasDetails;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: l10n.islamicDaysTitle,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: () => Navigator.of(
            context,
          ).push(AppPageRoute<void>(builder: (_) => const IslamicDaysView())),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome_outlined, color: accent, size: 19),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        entry == null
                            ? l10n.islamicDaysTitle
                            : '${l10n.islamicDaysTitle} · ${isToday ? l10n.islamicDaysToday : l10n.islamicDaysUpcoming}',
                        style: AppTheme.text(context).labelLarge.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_outward_rounded, color: accent, size: 20),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  entry?.event.title.resolve(l10n.localeName) ??
                      l10n.islamicDaysExplore,
                  style: AppTheme.text(
                    context,
                  ).titleMedium.copyWith(fontWeight: FontWeight.w800),
                ),
                if (hasDetails) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.xs,
                    children: [
                      if (entry != null && !isToday)
                        Text(
                          islamicDayGregorianLabel(l10n, entry!.date),
                          style: AppTheme.text(
                            context,
                          ).bodySmall.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      if (prohibited)
                        Text(
                          l10n.islamicDaysProhibited,
                          style: AppTheme.text(context).bodySmall.copyWith(
                            color: accent,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      if (todayCount > 1)
                        Text(
                          '${l10n.islamicDaysMoreToday} · ${islamicDayNumber(l10n, todayCount - 1)}',
                          style: AppTheme.text(
                            context,
                          ).bodySmall.copyWith(color: scheme.onSurfaceVariant),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

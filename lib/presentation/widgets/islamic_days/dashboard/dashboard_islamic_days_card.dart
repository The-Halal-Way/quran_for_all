import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../../data/models/islamic_days/islamic_day.dart';
import '../../../models/islamic_day_presenter.dart';
import '../../../viewmodels/islamic_days/islamic_days_viewmodel.dart';
import '../../../views/islamic_days/islamic_days_view.dart';
import '../shared/islamic_days_artwork.dart';

class DashboardIslamicDaysCard extends StatelessWidget {
  const DashboardIslamicDaysCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select(
      (IslamicDaysViewModel vm) => (
        entry: vm.today.isNotEmpty ? vm.today.first : vm.upcoming.firstOrNull,
        todayCount: vm.today.length,
      ),
    );
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final entry = state.entry;
    final isToday = state.todayCount > 0;
    final prohibited =
        entry?.dayFasting == IslamicDayFasting.prohibited && isToday;
    final accent = prohibited ? scheme.error : scheme.primary;
    final hasDetails =
        prohibited || state.todayCount > 1 || (entry != null && !isToday);
    return Semantics(
      button: true,
      label: l10n.islamicDaysTitle,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: accent.withValues(alpha: .2)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.alphaBlend(accent.withValues(alpha: .10), scheme.surface),
              Color.alphaBlend(
                scheme.tertiary.withValues(alpha: .045),
                scheme.surface,
              ),
            ],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.of(
              context,
            ).push(AppPageRoute<void>(builder: (_) => const IslamicDaysView())),
            child: Stack(
              children: [
                Positioned(
                  right: -32,
                  top: -36,
                  width: 150,
                  height: 150,
                  child: Opacity(
                    opacity: .23,
                    child: IslamicDaysArtwork(color: accent),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome_outlined,
                            color: accent,
                            size: 19,
                          ),
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
                          const Icon(Icons.arrow_outward_rounded, size: 20),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        entry?.event.title.resolve(l10n.localeName) ??
                            l10n.islamicDaysExplore,
                        style: AppTheme.text(
                          context,
                        ).titleMedium.copyWith(fontWeight: FontWeight.w800),
                      ),
                      if (hasDetails) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.xs,
                          children: [
                            if (entry != null && !isToday)
                              Text(
                                islamicDayGregorianLabel(l10n, entry.date),
                                style: AppTheme.text(context).bodySmall
                                    .copyWith(color: scheme.onSurfaceVariant),
                              ),
                            if (prohibited)
                              Text(
                                l10n.islamicDaysProhibited,
                                style: AppTheme.text(context).bodySmall
                                    .copyWith(
                                      color: accent,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            if (state.todayCount > 1)
                              Text(
                                '${l10n.islamicDaysMoreToday} · ${islamicDayNumber(l10n, state.todayCount - 1)}',
                                style: AppTheme.text(context).bodySmall
                                    .copyWith(color: scheme.onSurfaceVariant),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

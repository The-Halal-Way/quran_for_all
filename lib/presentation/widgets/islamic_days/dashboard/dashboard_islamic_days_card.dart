import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
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
    final vm = context.watch<IslamicDaysViewModel>();
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final entry = vm.today.isNotEmpty
        ? vm.today.first
        : vm.upcoming.isNotEmpty
        ? vm.upcoming.first
        : null;
    final prohibited =
        entry?.dayFasting == IslamicDayFasting.prohibited &&
        vm.today.isNotEmpty;
    final accent = prohibited ? scheme.error : scheme.primary;
    return Semantics(
      button: true,
      label: l10n.islamicDaysTitle,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
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
                  right: -45,
                  top: -45,
                  width: 185,
                  height: 185,
                  child: Opacity(
                    opacity: .23,
                    child: IslamicDaysArtwork(color: accent),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
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
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.islamicDaysTitle,
                              style: AppTheme.text(context).labelLarge.copyWith(
                                color: accent,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_outward_rounded, size: 20),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        entry?.event.title.resolve(l10n.localeName) ??
                            l10n.islamicDaysSubtitle,
                        style: AppTheme.text(
                          context,
                        ).titleLarge.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        entry == null
                            ? l10n.islamicDaysExplore
                            : '${vm.today.isNotEmpty ? l10n.islamicDaysToday : l10n.islamicDaysNextOccasion} · ${islamicDayHijriLabel(l10n, entry)}',
                        style: AppTheme.text(
                          context,
                        ).bodySmall.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      if (prohibited) ...[
                        const SizedBox(height: 12),
                        Text(
                          l10n.islamicDaysProhibited,
                          style: AppTheme.text(
                            context,
                          ).labelLarge.copyWith(color: accent),
                        ),
                      ],
                      if (vm.today.length > 1) ...[
                        const SizedBox(height: 8),
                        Text(
                          '${l10n.islamicDaysMoreToday} · ${islamicDayNumber(l10n, vm.today.length - 1)}',
                          style: AppTheme.text(
                            context,
                          ).labelSmall.copyWith(color: accent),
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

import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../viewmodels/dashboard/dashboard_viewmodel.dart';
import 'dashboard_prayer_error_card.dart';
import 'dashboard_prayer_row.dart';
import 'dashboard_prayer_summary.dart';

class DashboardPrayerCard extends StatefulWidget {
  const DashboardPrayerCard({
    super.key,
    required this.times,
    required this.ranges,
    required this.current,
    required this.loading,
    required this.onRetry,
    this.errorTitle,
    this.errorMessage,
  });
  final Map<String, String> times, ranges;
  final String? current, errorTitle, errorMessage;
  final bool loading;
  final VoidCallback onRetry;

  @override
  State<DashboardPrayerCard> createState() => _DashboardPrayerCardState();
}

class _DashboardPrayerCardState extends State<DashboardPrayerCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final model = DashboardViewModel();
    return Material(
      color: colors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: colors.outline.withValues(alpha: 0.5)),
      ),
      child: widget.loading && widget.times.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          : widget.errorTitle != null && widget.times.isEmpty
          ? DashboardPrayerErrorCard(
              title: widget.errorTitle!,
              message: widget.errorMessage ?? '',
              onRetry: widget.onRetry,
            )
          : Column(
              children: [
                DashboardPrayerSummary(
                  title: widget.current == null
                      ? context.l10n.dashboardSectionPrayerTimes
                      : model.localizedPrayerName(
                          context.l10n,
                          widget.current!,
                        ),
                  time: widget.times[widget.current] ?? '--:--',
                  icon: model.prayerIcon(widget.current ?? ''),
                  expanded: _expanded,
                  onToggle: () => setState(() => _expanded = !_expanded),
                ),
                AnimatedSize(
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : const Duration(milliseconds: 180),
                  alignment: Alignment.topCenter,
                  child: _expanded
                      ? Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            children: [
                              for (final entry in widget.times.entries)
                                DashboardPrayerRow(
                                  name: model.localizedPrayerName(
                                    context.l10n,
                                    entry.key,
                                  ),
                                  time: widget.ranges[entry.key] ?? entry.value,
                                  icon: model.prayerIcon(entry.key),
                                  isCurrent: entry.key == widget.current,
                                ),
                            ],
                          ),
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ],
            ),
    );
  }
}

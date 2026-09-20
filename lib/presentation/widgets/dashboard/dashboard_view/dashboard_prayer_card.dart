import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/prayer/prayer_detail_models.dart';
import '../../../viewmodels/dashboard/dashboard_viewmodel.dart';
import 'dashboard_forbidden_time_row.dart';
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
    this.forbiddenTimes = const [],
    this.onForbiddenTimesTap,
    this.errorTitle,
    this.errorMessage,
  });
  final Map<String, String> times, ranges;
  final List<PrayerForbiddenTimeItem> forbiddenTimes;
  final String? current, errorTitle, errorMessage;
  final bool loading;
  final VoidCallback onRetry;
  final VoidCallback? onForbiddenTimesTap;

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
                            children: _timelineRows(context, model),
                          ),
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ],
            ),
    );
  }

  List<Widget> _timelineRows(BuildContext context, DashboardViewModel model) {
    const prayerOrder = [
      'Sehri',
      'Fajr',
      'Sunrise',
      'Dhuhr',
      'Asr',
      'Maghrib',
      'Isha',
    ];
    final rows = <Widget>[];

    void addForbiddenTime(int index) {
      if (index >= widget.forbiddenTimes.length) {
        return;
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: DashboardForbiddenTimeRow(
            item: widget.forbiddenTimes[index],
            onTap: widget.onForbiddenTimesTap ?? () {},
          ),
        ),
      );
    }

    void addPrayer(String key, String value) {
      rows.add(
        DashboardPrayerRow(
          name: model.localizedPrayerName(context.l10n, key),
          time: widget.ranges[key] ?? value,
          icon: model.prayerIcon(key),
          isCurrent: key == widget.current,
        ),
      );
    }

    for (final key in prayerOrder) {
      if (key == 'Dhuhr') {
        addForbiddenTime(1);
      } else if (key == 'Maghrib') {
        addForbiddenTime(2);
      }

      final value = widget.times[key];
      if (value != null) {
        addPrayer(key, value);
      }

      if (key == 'Sunrise') {
        addForbiddenTime(0);
      }
    }

    for (final entry in widget.times.entries) {
      if (!prayerOrder.contains(entry.key)) {
        addPrayer(entry.key, entry.value);
      }
    }

    return rows;
  }
}

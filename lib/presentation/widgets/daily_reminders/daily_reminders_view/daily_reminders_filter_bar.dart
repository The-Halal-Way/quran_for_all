import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../models/daily_reminder_presenter.dart';
import '../../../viewmodels/daily_reminders/daily_reminders_viewmodel.dart';

class DailyRemindersFilterBar extends StatelessWidget {
  const DailyRemindersFilterBar({
    super.key,
    required this.l10n,
    required this.kinds,
    required this.selectedKind,
    required this.feedFilter,
    required this.onQueryChanged,
    required this.onKindChanged,
    required this.onFeedFilterChanged,
  });

  final AppLocalizations l10n;
  final List<String> kinds;
  final String? selectedKind;
  final DailyReminderFeedFilter feedFilter;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String?> onKindChanged;
  final ValueChanged<DailyReminderFeedFilter> onFeedFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: onQueryChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: l10n.dailyRemindersSearchHint,
            prefixIcon: const Icon(Icons.search_rounded),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FeedChip(
                label: l10n.dailyRemindersAll,
                selected: feedFilter == DailyReminderFeedFilter.all,
                onTap: () => onFeedFilterChanged(DailyReminderFeedFilter.all),
              ),
              _FeedChip(
                label: l10n.dailyRemindersUnread,
                selected: feedFilter == DailyReminderFeedFilter.unread,
                onTap: () =>
                    onFeedFilterChanged(DailyReminderFeedFilter.unread),
              ),
              _FeedChip(
                label: l10n.dailyRemindersSaved,
                selected: feedFilter == DailyReminderFeedFilter.saved,
                onTap: () => onFeedFilterChanged(DailyReminderFeedFilter.saved),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _KindChip(
                label: dailyReminderKindLabel(l10n, null),
                selected: selectedKind == null,
                onTap: () => onKindChanged(null),
              ),
              ...kinds.map(
                (kind) => _KindChip(
                  label: dailyReminderKindLabel(l10n, kind),
                  selected: selectedKind == kind,
                  onTap: () => onKindChanged(kind),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeedChip extends StatelessWidget {
  const _FeedChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
    child: ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    ),
  );
}

class _KindChip extends StatelessWidget {
  const _KindChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
    child: FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    ),
  );
}

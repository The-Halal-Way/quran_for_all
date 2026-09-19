import 'package:flutter/cupertino.dart';
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
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.55),
          width: 0.7,
        ),
      ),
      child: Column(
        children: [
          CupertinoSearchTextField(
            onChanged: onQueryChanged,
            placeholder: l10n.dailyRemindersSearchHint,
            backgroundColor: colors.surfaceContainerHighest.withValues(
              alpha: 0.7,
            ),
            itemColor: colors.onSurfaceVariant,
            style: TextStyle(color: colors.onSurface),
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 11),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: CupertinoSlidingSegmentedControl<DailyReminderFeedFilter>(
              groupValue: feedFilter,
              backgroundColor: colors.surfaceContainerHighest.withValues(
                alpha: 0.72,
              ),
              thumbColor: colors.surface,
              children: {
                DailyReminderFeedFilter.all: _SegmentLabel(
                  l10n.dailyRemindersAll,
                ),
                DailyReminderFeedFilter.unread: _SegmentLabel(
                  l10n.dailyRemindersUnread,
                ),
                DailyReminderFeedFilter.saved: _SegmentLabel(
                  l10n.dailyRemindersSaved,
                ),
              },
              onValueChanged: (value) {
                if (value != null) onFeedFilterChanged(value);
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _CategoryButton(
            label: dailyReminderKindLabel(l10n, selectedKind),
            isFiltered: selectedKind != null,
            onTap: () => _showCategoryPicker(context),
          ),
        ],
      ),
    );
  }

  Future<void> _showCategoryPicker(BuildContext context) async {
    final selected = await showCupertinoModalPopup<String>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(sheetContext).pop(''),
            child: _ActionLabel(
              label: dailyReminderKindLabel(l10n, null),
              selected: selectedKind == null,
            ),
          ),
          for (final kind in kinds)
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(sheetContext).pop(kind),
              child: _ActionLabel(
                label: dailyReminderKindLabel(l10n, kind),
                selected: selectedKind == kind,
              ),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(sheetContext).pop(),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
      ),
    );
    if (selected == null || !context.mounted) return;
    onKindChanged(selected.isEmpty ? null : selected);
  }
}

class _SegmentLabel extends StatelessWidget {
  const _SegmentLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
    child: Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
    ),
  );
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.label,
    required this.isFiltered,
    required this.onTap,
  });

  final String label;
  final bool isFiltered;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.base),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.line_horizontal_3_decrease,
              size: 18,
              color: isFiltered ? colors.primary : colors.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isFiltered ? colors.primary : colors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              CupertinoIcons.chevron_up_chevron_down,
              size: 16,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionLabel extends StatelessWidget {
  const _ActionLabel({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
      if (selected) ...[
        const SizedBox(width: 8),
        const Icon(CupertinoIcons.checkmark, size: 17),
      ],
    ],
  );
}

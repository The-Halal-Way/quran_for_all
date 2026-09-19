import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class DailyReminderReaderActions extends StatelessWidget {
  const DailyReminderReaderActions({
    super.key,
    required this.l10n,
    required this.isSaved,
    required this.canAddChecklist,
    required this.onToggleSaved,
    required this.onShare,
    required this.onAddChecklist,
  });

  final AppLocalizations l10n;
  final bool isSaved;
  final bool canAddChecklist;
  final VoidCallback onToggleSaved;
  final VoidCallback onShare;
  final VoidCallback onAddChecklist;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      _ReaderActionButton(
        onPressed: onToggleSaved,
        icon: isSaved ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
        selected: isSaved,
        tooltip: isSaved ? l10n.dailyRemindersUnsave : l10n.dailyRemindersSave,
      ),
      const SizedBox(width: AppSpacing.sm),
      _ReaderActionButton(
        onPressed: onShare,
        icon: CupertinoIcons.share,
        tooltip: l10n.dailyRemindersShare,
      ),
      if (canAddChecklist)
        Padding(
          padding: const EdgeInsetsDirectional.only(start: AppSpacing.sm),
          child: _ReaderActionButton(
            onPressed: onAddChecklist,
            icon: CupertinoIcons.checkmark_rectangle,
            selected: true,
            tooltip: l10n.dailyRemindersAddChecklist,
          ),
        ),
    ],
  );
}

class _ReaderActionButton extends StatelessWidget {
  const _ReaderActionButton({
    required this.onPressed,
    required this.icon,
    required this.tooltip,
    this.selected = false,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String tooltip;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: 20),
      color: selected ? colors.primary : colors.onSurface,
      style: IconButton.styleFrom(
        minimumSize: const Size.square(44),
        fixedSize: const Size.square(44),
        backgroundColor: selected
            ? colors.primary.withValues(alpha: 0.13)
            : colors.surfaceContainerHighest.withValues(alpha: 0.76),
        side: BorderSide(
          color: selected
              ? colors.primary.withValues(alpha: 0.26)
              : colors.outlineVariant.withValues(alpha: 0.58),
          width: 0.7,
        ),
      ),
    );
  }
}

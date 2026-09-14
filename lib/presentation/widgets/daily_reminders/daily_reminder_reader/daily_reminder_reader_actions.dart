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
      IconButton.filledTonal(
        onPressed: onToggleSaved,
        icon: Icon(
          isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        ),
        tooltip: isSaved ? l10n.dailyRemindersUnsave : l10n.dailyRemindersSave,
      ),
      const SizedBox(width: AppSpacing.sm),
      IconButton.filledTonal(
        onPressed: onShare,
        icon: const Icon(Icons.share_rounded),
        tooltip: l10n.dailyRemindersShare,
      ),
      if (canAddChecklist)
        Padding(
          padding: const EdgeInsetsDirectional.only(start: AppSpacing.sm),
          child: IconButton.filled(
            onPressed: onAddChecklist,
            icon: const Icon(Icons.playlist_add_check_circle_rounded),
            tooltip: l10n.dailyRemindersAddChecklist,
          ),
        ),
    ],
  );
}

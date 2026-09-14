import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/daily_reminder_notification_service.dart';

class DailyReminderPermissionBadge extends StatelessWidget {
  const DailyReminderPermissionBadge({
    super.key,
    required this.status,
    required this.l10n,
  });

  final DailyReminderPermissionStatus status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final granted = status == DailyReminderPermissionStatus.granted;
    final color = granted
        ? Theme.of(context).colorScheme.tertiary
        : Theme.of(context).colorScheme.outline;
    final label = switch (status) {
      DailyReminderPermissionStatus.granted =>
        l10n.dailyRemindersPermissionGranted,
      DailyReminderPermissionStatus.denied =>
        l10n.dailyRemindersPermissionDenied,
      DailyReminderPermissionStatus.unsupported =>
        l10n.dailyRemindersPermissionUnsupported,
      DailyReminderPermissionStatus.unknown =>
        l10n.dailyRemindersPermissionUnknown,
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            granted ? Icons.check_circle_rounded : Icons.info_outline_rounded,
            size: 17,
            color: color,
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(child: Text(label)),
        ],
      ),
    );
  }
}

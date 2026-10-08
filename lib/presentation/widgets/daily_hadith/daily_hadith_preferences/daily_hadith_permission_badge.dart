import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/daily_hadith_notification_service.dart';

class DailyHadithPermissionBadge extends StatelessWidget {
  const DailyHadithPermissionBadge({
    super.key,
    required this.status,
    required this.l10n,
  });

  final DailyHadithPermissionStatus status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final granted = status == DailyHadithPermissionStatus.granted;
    final color = granted
        ? Theme.of(context).colorScheme.tertiary
        : Theme.of(context).colorScheme.outline;
    final label = switch (status) {
      DailyHadithPermissionStatus.granted => l10n.dailyHadithPermissionGranted,
      DailyHadithPermissionStatus.denied => l10n.dailyHadithPermissionDenied,
      DailyHadithPermissionStatus.unsupported =>
        l10n.dailyHadithPermissionUnsupported,
      DailyHadithPermissionStatus.unknown => l10n.dailyHadithPermissionUnknown,
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
            granted
                ? CupertinoIcons.checkmark_circle_fill
                : CupertinoIcons.info_circle,
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

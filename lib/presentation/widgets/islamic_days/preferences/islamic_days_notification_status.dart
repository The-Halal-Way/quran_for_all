import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../services/notifications/app_notification_coordinator.dart';
import '../../../viewmodels/islamic_days/islamic_days_viewmodel.dart';

class IslamicDaysNotificationStatus extends StatelessWidget {
  const IslamicDaysNotificationStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<IslamicDaysViewModel>();
    final l10n = context.l10n;
    final message = vm.notificationError != null
        ? l10n.islamicDaysNotificationError
        : vm.permission == AppNotificationPermission.unsupported
        ? l10n.islamicDaysNotificationsUnavailable
        : vm.permission == AppNotificationPermission.denied
        ? l10n.islamicDaysNotificationsDenied
        : null;
    if (message == null) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).colorScheme.error.withValues(alpha: .06),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: AppTheme.text(context).bodySmall.copyWith(height: 1.55),
          ),
          if (vm.notificationError != null)
            TextButton.icon(
              onPressed: () => vm.refresh(force: true),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(l10n.islamicDaysRetry),
            ),
        ],
      ),
    );
  }
}

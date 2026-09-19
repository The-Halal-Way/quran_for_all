import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class DashboardPrayerErrorCard extends StatelessWidget {
  const DashboardPrayerErrorCard({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
  });
  final String title, message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTheme.text(context).titleSmall),
        const SizedBox(height: AppSpacing.sm),
        Text(message, style: AppTheme.text(context).bodySmall),
        const SizedBox(height: AppSpacing.sm),
        TextButton.icon(
          onPressed: onRetry,
          icon: const Icon(CupertinoIcons.refresh),
          label: Text(context.l10n.dashboardRetry),
        ),
      ],
    ),
  );
}

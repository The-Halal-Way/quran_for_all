import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class DailyTrackerSectionOrderHeader extends StatelessWidget {
  const DailyTrackerSectionOrderHeader({super.key, required this.onReset});

  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        context.l10n.dailyTrackerOrganizeSectionsAction,
        style: AppTheme.text(
          context,
        ).titleLarge.copyWith(fontWeight: AppTheme.weightBold),
      ),
      const SizedBox(height: AppSpacing.sm),
      Text(
        context.l10n.dailyTrackerOrganizeSectionsSubtitle,
        style: AppTheme.text(context).bodySmall,
      ),
      TextButton.icon(
        onPressed: onReset,
        icon: const Icon(Icons.restart_alt_rounded, size: 18),
        label: Text(context.l10n.dailyTrackerResetSectionOrderAction),
      ),
    ],
  );
}

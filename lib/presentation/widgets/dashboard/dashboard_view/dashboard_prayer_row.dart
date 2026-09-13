import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

class DashboardPrayerRow extends StatelessWidget {
  const DashboardPrayerRow({
    super.key,
    required this.name,
    required this.time,
    required this.icon,
    required this.isCurrent,
  });
  final String name, time;
  final IconData icon;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = dark ? MyColors.secondaryLight : MyColors.secondary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isCurrent ? accent : colors.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Wrap(
              spacing: 6,
              runSpacing: 3,
              children: [
                Text(
                  name,
                  style: AppTheme.text(context).bodyMedium.copyWith(
                    fontWeight: isCurrent
                        ? AppTheme.weightBold
                        : AppTheme.weightMedium,
                  ),
                ),
                if (isCurrent)
                  Text(
                    context.l10n.dashboardNowShortLabel,
                    style: AppTheme.text(
                      context,
                    ).labelSmall.copyWith(color: accent),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              time,
              textAlign: TextAlign.end,
              style: AppTheme.text(context).bodySmall.copyWith(
                color: isCurrent ? accent : colors.onSurfaceVariant,
                fontWeight: AppTheme.weightSemiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

class DailyTrackerStat extends StatelessWidget {
  const DailyTrackerStat({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
  });
  final int value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(AppRadius.md),
      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
    ),
    child: Row(
      children: [
        Icon(icon, color: MyColors.tertiaryLight, size: 17),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            '${NumberFormat.decimalPattern(context.l10n.localeName).format(value)} $label',
            style: AppTheme.text(context).labelMedium.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.weightBold,
            ),
          ),
        ),
      ],
    ),
  );
}

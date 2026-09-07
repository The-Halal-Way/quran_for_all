import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/my_colors.dart';

class PowerfulDuahCountBadge extends StatelessWidget {
  const PowerfulDuahCountBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.secondary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        context.l10n.duahCountLabel(count),
        style: AppTheme.text(context).labelSmall.copyWith(
          color: MyColors.secondary,
          fontWeight: AppTheme.weightExtraBold,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class SunnahDuaItemCount extends StatelessWidget {
  const SunnahDuaItemCount({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.onSurface.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        context.l10n.sunnahDuaItemsCount(count),
        style: AppTheme.text(context).labelSmall.copyWith(
          color: colors.onSurface,
          fontWeight: AppTheme.weightBold,
        ),
      ),
    );
  }
}

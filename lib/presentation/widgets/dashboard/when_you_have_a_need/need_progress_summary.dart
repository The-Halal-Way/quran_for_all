import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../viewmodels/dashboard/need_amal_progress_viewmodel.dart';

class NeedProgressSummary extends StatelessWidget {
  const NeedProgressSummary({
    super.key,
    required this.isBangla,
    required this.total,
  });

  final bool isBangla;
  final int total;

  @override
  Widget build(BuildContext context) {
    final completed = context.watch<NeedAmalProgressViewModel>().completedCount;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_rounded, color: scheme.secondary, size: 27),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              isBangla ? 'আজকের ব্যক্তিগত আমল' : 'Your personal practice today',
              style: AppTheme.text(
                context,
              ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
            ),
          ),
          Text(
            '$completed / $total',
            style: AppTheme.text(context).titleMedium.copyWith(
              color: scheme.tertiary,
              fontWeight: AppTheme.weightExtraBold,
            ),
          ),
        ],
      ),
    );
  }
}

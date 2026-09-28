import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../views/dashboard/when_you_have_a_need/need_amal.dart';

class NeedEvidencePanel extends StatelessWidget {
  const NeedEvidencePanel({
    super.key,
    required this.amal,
    required this.isBangla,
  });

  final NeedAmal amal;
  final bool isBangla;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.secondary.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isBangla ? 'প্রমাণের মান' : 'Authenticity',
            style: AppTheme.text(context).labelSmall.copyWith(
              color: scheme.secondary,
              fontWeight: AppTheme.weightExtraBold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            amal.authenticity.of(isBangla),
            style: AppTheme.text(
              context,
            ).titleSmall.copyWith(fontWeight: AppTheme.weightExtraBold),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            amal.evidenceNote.of(isBangla),
            style: AppTheme.text(context).bodySmall.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}

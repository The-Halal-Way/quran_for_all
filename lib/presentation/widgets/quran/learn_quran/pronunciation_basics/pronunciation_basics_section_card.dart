import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';

class PronunciationBasicsSectionCard extends StatelessWidget {
  const PronunciationBasicsSectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg - 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.learnText(title),
              style: AppTheme.text(
                context,
              ).titleMedium.copyWith(fontWeight: AppTheme.weightBold),
            ),
            const SizedBox(height: AppSpacing.xs + 1),
            Text(
              context.learnText(subtitle),
              style: AppTheme.text(context).bodySmall,
            ),
            const SizedBox(height: AppSpacing.sm + 2),
            child,
          ],
        ),
      ),
    );
  }
}

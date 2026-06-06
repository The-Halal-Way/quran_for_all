import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../../core/localization/l10n_extensions.dart';

class PronunciationBasicsStepChip extends StatelessWidget {
  const PronunciationBasicsStepChip({
    super.key,
    required this.step,
    required this.label,
  });

  final int step;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.full),
        color: colorScheme.primary.withValues(alpha: 0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: colorScheme.primary,
            child: Text(
              '$step',
              style: AppTheme.text(context).labelSmall.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: AppTheme.weightBold,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            context.learnText(label),
            style: AppTheme.text(context).labelMedium.copyWith(
              color: colorScheme.primary,
              fontWeight: AppTheme.weightBold,
            ),
          ),
        ],
      ),
    );
  }
}

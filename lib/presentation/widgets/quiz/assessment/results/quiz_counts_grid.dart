import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/quiz/quiz_result.dart';
import '../../shared/quiz_labels.dart';

class QuizCountsGrid extends StatelessWidget {
  const QuizCountsGrid({super.key, required this.counts});
  final QuizCounts counts;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final values = counts.toJson();
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 600 ? 4 : 2;
        final width =
            (constraints.maxWidth - (columns - 1) * AppSpacing.sm) / columns;
        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final entry in values.entries)
              SizedBox(
                width: width,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(
                      color: QuizLabels.outcomeColor(
                        scheme,
                        entry.key,
                      ).withValues(alpha: .22),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        QuizLabels.number(l10n, entry.value as int),
                        style: AppTheme.text(context).headlineMedium.copyWith(
                          color: QuizLabels.outcomeColor(scheme, entry.key),
                          fontWeight: AppTheme.weightExtraBold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        QuizLabels.outcome(l10n, entry.key),
                        style: AppTheme.text(context).bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

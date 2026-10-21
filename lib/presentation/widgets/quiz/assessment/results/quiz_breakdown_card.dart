import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/quiz/quiz_result.dart';
import '../../shared/quiz_labels.dart';

class QuizBreakdownCard extends StatelessWidget {
  const QuizBreakdownCard({
    super.key,
    required this.title,
    required this.counts,
    this.byQuestionGroup = false,
  });
  final String title;
  final Map<String, QuizCounts> counts;
  final bool byQuestionGroup;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.text(
            context,
          ).titleMedium.copyWith(fontWeight: AppTheme.weightBold),
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                for (final entry in counts.entries)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                byQuestionGroup
                                    ? QuizLabels.questionGroup(l10n, entry.key)
                                    : QuizLabels.category(l10n, entry.key),
                                style: AppTheme.text(context).bodySmall,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              '${QuizLabels.number(l10n, entry.value.correct)}/${QuizLabels.number(l10n, entry.value.total)}',
                              style: AppTheme.text(context).labelMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        LinearProgressIndicator(
                          value: entry.value.total == 0
                              ? 0
                              : entry.value.correct / entry.value.total,
                          minHeight: 5,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/quiz/quiz_attempt.dart';
import '../../shared/quiz_labels.dart';

class QuizHistoryTile extends StatelessWidget {
  const QuizHistoryTile({
    super.key,
    required this.summary,
    required this.onTap,
  });
  final QuizAttemptSummary summary;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        leading: CircleAvatar(
          backgroundColor: scheme.primary.withValues(alpha: .1),
          child: Icon(Icons.history_edu_rounded, color: scheme.primary),
        ),
        title: Text(
          DateFormat.yMMMd(
            l10n.localeName,
          ).add_Hm().format(summary.completedAtUtc.toLocal()),
          style: AppTheme.text(context).labelMedium,
        ),
        subtitle: Text(
          l10n.quizCorrectOf(
            summary.result.counts.correct,
            summary.result.counts.total,
          ),
          style: AppTheme.text(context).bodySmall,
        ),
        trailing: Text(
          '${QuizLabels.number(l10n, summary.result.percentage, decimals: 1)}%',
          style: AppTheme.text(context).titleSmall.copyWith(
            color: scheme.primary,
            fontWeight: AppTheme.weightExtraBold,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/quiz/quiz_attempt.dart';
import '../shared/quiz_dialogs.dart';

class QuizResumeCard extends StatelessWidget {
  const QuizResumeCard({
    super.key,
    required this.attempt,
    required this.busy,
    required this.onResume,
    required this.onDiscard,
  });
  final QuizAttempt attempt;
  final bool busy;
  final VoidCallback onResume, onDiscard;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: scheme.primaryContainer.withValues(alpha: .4),
        border: Border.all(color: scheme.primary.withValues(alpha: .25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bookmark_added_rounded, color: scheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.quizResume,
                  style: AppTheme.text(
                    context,
                  ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LinearProgressIndicator(
            value: attempt.answeredCount / attempt.questionOrder.length,
            minHeight: 6,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.quizAnsweredCount(
              attempt.answeredCount,
              attempt.questionOrder.length,
            ),
            style: AppTheme.text(context).bodySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${l10n.quizLanguage}: ${attempt.config.languageName(attempt.language)}',
            style: AppTheme.text(
              context,
            ).labelMedium.copyWith(fontWeight: AppTheme.weightBold),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.quizLanguageLocked,
            style: AppTheme.text(context).bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: busy ? null : onResume,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(l10n.quizResume),
          ),
          TextButton(
            onPressed: busy
                ? null
                : () async {
                    if (await confirmQuizDiscard(context) && context.mounted) {
                      onDiscard();
                    }
                  },
            child: Text(l10n.quizDiscard),
          ),
        ],
      ),
    );
  }
}

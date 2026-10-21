import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/app_responsive.dart';
import '../../../../viewmodels/quiz/quiz_viewmodel.dart';
import 'quiz_breakdown_card.dart';
import 'quiz_counts_grid.dart';
import '../../shared/quiz_notice.dart';
import 'quiz_result_score_card.dart';

class QuizResultsBody extends StatelessWidget {
  const QuizResultsBody({super.key, required this.model});
  final QuizViewModel model;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final attempt = model.attempt!;
    final result = attempt.result!;
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppResponsive.of(context).padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          QuizResultScoreCard(attempt: attempt),
          const SizedBox(height: AppSpacing.md),
          QuizNotice(message: l10n.quizSampleNotice),
          const SizedBox(height: AppSpacing.lg),
          QuizCountsGrid(counts: result.counts),
          const SizedBox(height: AppSpacing.lg),
          if (attempt.config.categoryBreakdown) ...[
            QuizBreakdownCard(
              title: l10n.quizSubjectBreakdown,
              counts: result.categories,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          if (attempt.config.groupBreakdown) ...[
            QuizBreakdownCard(
              title: attempt.config.usesQuestionStyles
                  ? l10n.quizStyleBreakdown
                  : l10n.quizDifficultyBreakdown,
              counts: result.groupCounts,
              byQuestionGroup: true,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          if (attempt.config.reviewFlag('availableAfterSubmission'))
            FilledButton.icon(
              onPressed: model.busy ? null : model.showReview,
              icon: const Icon(Icons.menu_book_rounded),
              label: Text(l10n.quizReview),
            ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(
            onPressed: model.busy ? null : model.back,
            child: Text(
              model.config?.retakeEnabled == true && model.active == null
                  ? l10n.quizRetake
                  : l10n.quizBackToOverview,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

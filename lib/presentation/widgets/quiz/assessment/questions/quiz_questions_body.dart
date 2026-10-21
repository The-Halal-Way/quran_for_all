import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/app_responsive.dart';
import '../../../../viewmodels/quiz/quiz_viewmodel.dart';
import '../../shared/quiz_labels.dart';
import '../../shared/quiz_notice.dart';
import 'quiz_question_card.dart';
import 'quiz_question_footer.dart';
import 'quiz_question_navigator.dart';

class QuizQuestionsBody extends StatelessWidget {
  const QuizQuestionsBody({super.key, required this.model});
  final QuizViewModel model;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final attempt = model.attempt!;
    final remaining = model.secondsRemaining;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.quizProgress(
                        attempt.currentIndex + 1,
                        attempt.questionOrder.length,
                      ),
                      style: AppTheme.text(context).labelMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: model.busy
                        ? null
                        : () => showQuizQuestionNavigator(context, model),
                    tooltip: l10n.quizNavigator,
                    icon: const Icon(Icons.grid_view_rounded),
                  ),
                ],
              ),
              LinearProgressIndicator(
                value: attempt.answeredCount / attempt.questionOrder.length,
                minHeight: 5,
                borderRadius: BorderRadius.circular(8),
              ),
              if (remaining != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    remaining <= 0
                        ? l10n.quizTimeExpired
                        : '${l10n.quizTimeRemaining}: ${QuizLabels.number(l10n, remaining ~/ 60)}:${(remaining % 60).toString().padLeft(2, '0')}',
                    style: AppTheme.text(context).labelSmall,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            key: ValueKey(attempt.currentId),
            padding: EdgeInsets.all(AppResponsive.of(context).padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (attempt.reusedCount > 0 && attempt.currentIndex == 0) ...[
                  QuizNotice(message: l10n.quizReusedNotice),
                  const SizedBox(height: AppSpacing.md),
                ],
                QuizQuestionCard(model: model),
              ],
            ),
          ),
        ),
        QuizQuestionFooter(model: model),
      ],
    );
  }
}

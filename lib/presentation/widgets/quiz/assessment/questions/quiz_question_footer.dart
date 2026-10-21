import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../viewmodels/quiz/quiz_viewmodel.dart';
import '../shared/quiz_dialogs.dart';

class QuizQuestionFooter extends StatelessWidget {
  const QuizQuestionFooter({super.key, required this.model});
  final QuizViewModel model;

  Future<void> _submit(BuildContext context) async {
    final current = model.attempt!;
    if (current.unansweredCount > 0 && current.config.confirmUnanswered) {
      if (!await confirmQuizSubmission(context)) return;
    }
    if (context.mounted) await model.submit();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final attempt = model.attempt!;
    final last = attempt.currentIndex == attempt.questionOrder.length - 1;
    final answered = attempt.responses[attempt.currentId]?.status.name;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (attempt.config.allowBack) ...[
                  OutlinedButton(
                    onPressed:
                        !model.busy &&
                            model.canNavigate(attempt.currentIndex - 1)
                        ? () => model.navigate(attempt.currentIndex - 1)
                        : null,
                    child: const Icon(Icons.chevron_left_rounded),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: FilledButton.icon(
                    onPressed: model.busy
                        ? null
                        : last
                        ? () => _submit(context)
                        : model.canNavigate(attempt.currentIndex + 1)
                        ? () => model.navigate(attempt.currentIndex + 1)
                        : null,
                    icon: Icon(
                      last ? Icons.check_rounded : Icons.arrow_forward_rounded,
                    ),
                    label: Text(
                      last
                          ? l10n.quizSubmit
                          : attempt.config.allowSkip &&
                                (answered == null || answered == 'unanswered')
                          ? l10n.quizSkip
                          : l10n.quizNext,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              model.busy ? l10n.quizSaving : l10n.quizSaved,
              style: AppTheme.text(context).labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}

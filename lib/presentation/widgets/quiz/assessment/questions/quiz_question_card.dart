import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/quiz/quiz_result.dart';
import '../../../../viewmodels/quiz/quiz_viewmodel.dart';
import '../../shared/quiz_labels.dart';
import 'quiz_option_tile.dart';

class QuizQuestionCard extends StatelessWidget {
  const QuizQuestionCard({super.key, required this.model});
  final QuizViewModel model;
  @override
  Widget build(BuildContext context) {
    final attempt = model.attempt!;
    final question = attempt.currentQuestion;
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final response = attempt.responses[question.id];
    final locked =
        !attempt.config.allowChange &&
        response != null &&
        response.status != QuizResponseStatus.unanswered;
    final expired = (model.secondsRemaining ?? 1) <= 0;
    final canAnswer = !model.busy && !locked && !expired;
    if (!model.busy &&
        model.error == null &&
        !attempt.exposedIds.contains(question.id)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) model.recordDisplayed(question.id);
      });
    }
    final order = attempt.optionOrders[question.id]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(
              avatar: Icon(
                QuizLabels.categoryIcon(question.categoryId),
                size: 16,
              ),
              label: Text(QuizLabels.category(l10n, question.categoryId)),
            ),
            Chip(
              label: Text(
                QuizLabels.questionGroup(
                  l10n,
                  question.quotaGroup(attempt.config),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          question.question,
          style: AppTheme.text(
            context,
          ).titleMedium.copyWith(fontWeight: AppTheme.weightBold, height: 1.55),
        ),
        const SizedBox(height: AppSpacing.lg),
        for (var index = 0; index < order.length; index++)
          QuizOptionTile(
            key: ValueKey('${question.id}/${order[index]}'),
            text: question.optionText(order[index]),
            position: index,
            selected: response?.selectedOptionId == order[index],
            onTap: canAnswer
                ? () => model.answer(
                    QuizResponse(QuizResponseStatus.answered, order[index]),
                  )
                : null,
          ),
        if (attempt.config.allowUnknown) ...[
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: canAnswer
                ? () => model.answer(
                    const QuizResponse(QuizResponseStatus.unknown),
                  )
                : null,
            style: OutlinedButton.styleFrom(
              backgroundColor: response?.status == QuizResponseStatus.unknown
                  ? scheme.tertiary.withValues(alpha: .1)
                  : null,
            ),
            icon: Icon(
              response?.status == QuizResponseStatus.unknown
                  ? Icons.check_circle_outline_rounded
                  : Icons.help_outline_rounded,
            ),
            label: Text(l10n.quizNotSure),
          ),
        ],
        if (attempt.config.allowChange &&
            response != null &&
            response.status != QuizResponseStatus.unanswered)
          TextButton(
            onPressed: model.busy || expired
                ? null
                : () => model.answer(
                    const QuizResponse(QuizResponseStatus.unanswered),
                  ),
            child: Text(l10n.quizClear),
          ),
      ],
    );
  }
}

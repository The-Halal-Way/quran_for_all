import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/quiz/quiz_result.dart';
import '../../../../viewmodels/quiz/quiz_viewmodel.dart';
import '../../shared/quiz_labels.dart';

Future<void> showQuizQuestionNavigator(
  BuildContext context,
  QuizViewModel model,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (sheetContext) {
    final attempt = model.attempt!;
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * .7,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.quizNavigator, style: AppTheme.text(context).titleLarge),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (
                  var index = 0;
                  index < attempt.questionOrder.length;
                  index++
                )
                  _QuestionPosition(
                    label: QuizLabels.number(l10n, index + 1),
                    current: index == attempt.currentIndex,
                    color: switch (attempt
                        .responses[attempt.questionOrder[index]]
                        ?.status) {
                      QuizResponseStatus.answered => scheme.primary,
                      QuizResponseStatus.unknown => const Color(0xFFC38A25),
                      _ => scheme.onSurfaceVariant,
                    },
                    onTap: !model.busy && model.canNavigate(index)
                        ? () {
                            Navigator.pop(sheetContext);
                            model.navigate(index);
                          }
                        : null,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.quizAnsweredCount(
                attempt.answeredCount,
                attempt.questionOrder.length,
              ),
              style: AppTheme.text(context).bodySmall,
            ),
          ],
        ),
      ),
    );
  },
);

class _QuestionPosition extends StatelessWidget {
  const _QuestionPosition({
    required this.label,
    required this.current,
    required this.color,
    required this.onTap,
  });
  final String label;
  final bool current;
  final Color color;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    selected: current,
    child: SizedBox.square(
      dimension: 48,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: color,
          backgroundColor: color.withValues(alpha: current ? .2 : .07),
          side: BorderSide(
            color: color.withValues(alpha: current ? 1 : .25),
            width: current ? 2 : 1,
          ),
        ),
        child: Text(label),
      ),
    ),
  );
}

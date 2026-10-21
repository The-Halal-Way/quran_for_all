import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/quiz/quiz_attempt.dart';
import '../../../../../data/models/quiz/quiz_result.dart';
import '../../shared/quiz_labels.dart';

class QuizReviewCard extends StatelessWidget {
  const QuizReviewCard({
    super.key,
    required this.attempt,
    required this.questionId,
    required this.position,
  });
  final QuizAttempt attempt;
  final String questionId;
  final int position;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final config = attempt.config;
    final question = attempt.snapshots[questionId]!.inLanguage(
      attempt.language,
    );
    final response = attempt.responses[questionId];
    final outcome = quizOutcome(question, response);
    final color = QuizLabels.outcomeColor(scheme, outcome);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        key: PageStorageKey(
          'review-${attempt.id}-$questionId-${attempt.language}',
        ),
        tilePadding: const EdgeInsets.all(AppSpacing.md),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: .12),
          child: Text(
            QuizLabels.number(l10n, position),
            style: AppTheme.text(context).labelMedium.copyWith(color: color),
          ),
        ),
        title: Text(
          question.question,
          style: AppTheme.text(
            context,
          ).bodyMedium.copyWith(fontWeight: AppTheme.weightSemiBold),
        ),
        subtitle: Text(
          QuizLabels.outcome(l10n, outcome),
          style: AppTheme.text(context).labelSmall.copyWith(color: color),
        ),
        children: [
          if (config.reviewFlag('showSelectedAnswer'))
            _Answer(
              label: l10n.quizYourAnswer,
              value: response?.selectedOptionId == null
                  ? QuizLabels.outcome(l10n, outcome)
                  : question.optionText(response!.selectedOptionId!),
              color: color,
            ),
          if (config.reviewFlag('showCorrectAnswer'))
            _Answer(
              label: l10n.quizCorrectAnswer,
              value: question.optionText(question.correctOptionId),
              color: const Color(0xFF159A83),
            ),
          if (config.reviewFlag('showExplanation')) ...[
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                l10n.quizExplanation,
                style: AppTheme.text(context).labelLarge,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SelectableText(
              question.explanation,
              style: AppTheme.text(context).bodyMedium.copyWith(height: 1.6),
            ),
          ],
          if (config.reviewFlag('showReferences')) ...[
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                l10n.quizReferences,
                style: AppTheme.text(context).labelLarge,
              ),
            ),
            for (final reference in question.references)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child:
                    reference.url != null &&
                        config.reviewFlag('allowReferenceLinks')
                    ? TextButton.icon(
                        onPressed: () async {
                          var opened = false;
                          try {
                            opened = await launchUrl(
                              Uri.parse(reference.url!),
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (_) {
                            /* Keep reading if no browser is available. */
                          }
                          if (!opened && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.quizOpenLinkError)),
                            );
                          }
                        },
                        icon: const Icon(Icons.open_in_new_rounded, size: 15),
                        label: Text(reference.label),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          reference.label,
                          style: AppTheme.text(context).bodySmall,
                        ),
                      ),
              ),
          ],
        ],
      ),
    );
  }
}

class _Answer extends StatelessWidget {
  const _Answer({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label, value;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .07),
      borderRadius: BorderRadius.circular(AppRadius.md),
      border: Border(left: BorderSide(color: color, width: 3)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.text(context).labelSmall.copyWith(color: color),
        ),
        const SizedBox(height: 4),
        Text(value, style: AppTheme.text(context).bodyMedium),
      ],
    ),
  );
}

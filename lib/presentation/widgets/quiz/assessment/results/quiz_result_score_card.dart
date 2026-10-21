import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/quiz/quiz_attempt.dart';
import '../../shared/quiz_labels.dart';

class QuizResultScoreCard extends StatelessWidget {
  const QuizResultScoreCard({super.key, required this.attempt});
  final QuizAttempt attempt;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final result = attempt.result!;
    final percentage =
        '${QuizLabels.number(l10n, result.percentage, decimals: attempt.config.percentageDecimals)}%';
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: const LinearGradient(
          colors: [Color(0xFF303E87), Color(0xFF7540B1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            l10n.quizResultsTitle,
            textAlign: TextAlign.center,
            style: AppTheme.text(
              context,
            ).titleSmall.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: AppSpacing.lg),
          Semantics(
            label: percentage,
            child: ExcludeSemantics(
              child: SizedBox.square(
                dimension: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: result.percentage / 100,
                        strokeWidth: 8,
                        color: const Color(0xFF6FE6D1),
                        backgroundColor: Colors.white12,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: FittedBox(
                        child: Text(
                          percentage,
                          style: AppTheme.text(context).headlineMedium.copyWith(
                            color: Colors.white,
                            fontWeight: AppTheme.weightExtraBold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.quizCorrectOf(result.counts.correct, result.counts.total),
            textAlign: TextAlign.center,
            style: AppTheme.text(
              context,
            ).titleSmall.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

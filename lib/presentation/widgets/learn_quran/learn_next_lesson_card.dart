import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/learn_quran_content.dart';

class LearnNextLessonCard extends StatelessWidget {
  const LearnNextLessonCard({
    super.key,
    this.nextLesson,
    required this.onStart,
  });

  final LearnQuranLesson? nextLesson;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final lesson = nextLesson;
    final hasLesson = lesson != null;
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(
                    hasLesson
                        ? Icons.play_lesson_rounded
                        : Icons.verified_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm + 2),
                Expanded(
                  child: Text(
                    hasLesson
                        ? l10n.learnNextContinuePathTitle
                        : l10n.learnNextAllLessonsCompletedTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              hasLesson
                  ? context.learnText(lesson.title)
                  : l10n.learnNextAllLessonsCompletedBody,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (hasLesson) ...[
              const SizedBox(height: AppSpacing.sm - 2),
              Text(
                context.learnText(lesson.objective),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.74),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: onStart,
              icon: Icon(
                hasLesson
                    ? Icons.play_circle_fill_rounded
                    : Icons.refresh_rounded,
              ),
              label: Text(
                hasLesson
                    ? l10n.learnNextStartLessonButton
                    : l10n.learnNextReviewModulesButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

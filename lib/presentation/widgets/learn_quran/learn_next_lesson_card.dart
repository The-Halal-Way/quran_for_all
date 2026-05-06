import 'package:flutter/material.dart';

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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    hasLesson
                        ? Icons.play_lesson_rounded
                        : Icons.verified_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    hasLesson ? 'Continue your path' : 'All lessons completed',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              hasLesson
                  ? lesson.title
                  : 'Excellent work. Revisit any module to reinforce your learning.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (hasLesson) ...[
              const SizedBox(height: 6),
              Text(
                lesson.objective,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.74),
                ),
              ),
            ],
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onStart,
              icon: Icon(
                hasLesson
                    ? Icons.play_circle_fill_rounded
                    : Icons.refresh_rounded,
              ),
              label: Text(hasLesson ? 'Start Next Lesson' : 'Review Modules'),
            ),
          ],
        ),
      ),
    );
  }
}

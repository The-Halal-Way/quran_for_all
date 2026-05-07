import 'package:flutter/material.dart';

import '../../../data/models/learn_quran_content.dart';

class LearnLessonTile extends StatelessWidget {
  const LearnLessonTile({
    super.key,
    required this.lesson,
    required this.isCompleted,
    required this.isAudioPlaying,
    required this.onCompletionChanged,
    required this.onAudioTap,
  });

  final LearnQuranLesson lesson;
  final bool isCompleted;
  final bool isAudioPlaying;
  final ValueChanged<bool> onCompletionChanged;
  final VoidCallback? onAudioTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: isCompleted,
                  onChanged: (value) => onCompletionChanged(value ?? false),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lesson.objective,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                if (lesson.hasAudioSample)
                  IconButton.filledTonal(
                    onPressed: onAudioTap,
                    icon: Icon(
                      isAudioPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    tooltip: isAudioPlaying
                        ? 'Pause lesson sample audio'
                        : 'Play lesson sample audio',
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: colorScheme.secondary.withValues(alpha: 0.11),
              ),
              child: Text(
                lesson.practicePrompt,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _Tag(label: '${lesson.durationMinutes} min', icon: Icons.timer),
                if (lesson.hasAudioSample) ...[
                  const SizedBox(width: 8),
                  const _Tag(
                    label: 'Audio guided',
                    icon: Icons.graphic_eq_rounded,
                  ),
                ],
                if (isCompleted) ...[
                  const SizedBox(width: 8),
                  const _Tag(
                    label: 'Done',
                    icon: Icons.check_circle_rounded,
                    color: Color(0xFF1F8B4C),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.icon, this.color});

  final String label;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final baseColor = color ?? Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        color: baseColor.withValues(alpha: 0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: baseColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: baseColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

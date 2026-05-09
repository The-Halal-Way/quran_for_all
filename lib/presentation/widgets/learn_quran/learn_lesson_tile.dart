import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/learn_quran_content.dart';
import '../common/app_pill.dart';

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
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg - 2, AppSpacing.md, AppSpacing.lg - 2, AppSpacing.md),
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
                          context.learnText(lesson.title),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          context.learnText(lesson.objective),
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
                        ? l10n.learnLessonTooltipPauseAudio
                        : l10n.learnLessonTooltipPlayAudio,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm + 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                color: colorScheme.secondary.withValues(alpha: 0.11),
              ),
              child: Text(
                context.learnText(lesson.practicePrompt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                AppPill.surface(
                  label: l10n.learnLessonDurationMinutes(lesson.durationMinutes),
                  icon: Icons.timer,
                ),
                if (lesson.hasAudioSample) ...[
                  const SizedBox(width: AppSpacing.sm),
                  AppPill.surface(
                    label: l10n.learnLessonAudioGuided,
                    icon: Icons.graphic_eq_rounded,
                  ),
                ],
                if (isCompleted) ...[
                  const SizedBox(width: AppSpacing.sm),
                  AppPill.surface(
                    label: l10n.learnLessonDone,
                    icon: Icons.check_circle_rounded,
                    color: AppColors.success,
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

import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import 'audio_assisted_learning_data.dart';
import 'audio_assisted_section_card.dart';

// Section 5: Session plan and pacing routine.
class AudioAssistedSessionPlanSection extends StatelessWidget {
  const AudioAssistedSessionPlanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const AudioAssistedSectionCard(
      title: '4) Guided Audio Session Plan',
      subtitle:
          'Use a fixed routine to structure listening, imitation, correction, and final confidence recitation.',
      child: _SessionPlanList(),
    );
  }
}

class _SessionPlanList extends StatelessWidget {
  const _SessionPlanList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < AudioAssistedLearningData.sessionPlans.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _SessionPlanCard(
              index: i + 1,
              item: AudioAssistedLearningData.sessionPlans[i],
            ),
          ),
      ],
    );
  }
}

class _SessionPlanCard extends StatelessWidget {
  const _SessionPlanCard({required this.index, required this.item});

  final int index;
  final AudioSessionPlanGuide item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: colorScheme.secondary.withValues(alpha: 0.08),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: colorScheme.primary.withValues(alpha: 0.14),
            child: Text(
              '$index',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.phase,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  '${context.learnText('Duration')}: ${item.duration}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(item.task, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 3),
                Text(
                  '${context.learnText('Output')}: ${item.output}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

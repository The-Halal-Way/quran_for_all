import 'package:flutter/material.dart';

import 'audio_assisted_learning_data.dart';
import 'audio_assisted_section_card.dart';

// Section 7: Revision and mastery checklist.
class AudioAssistedRevisionSection extends StatelessWidget {
  const AudioAssistedRevisionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final mastery = <String>[
      'I can complete focused listening before imitation.',
      'I can shadow recite while maintaining phrase timing.',
      'I can detect and correct at least two repeating mistakes.',
      'I can recite solo with stable rhythm after audio guidance.',
      'I can compare my recording and explain one improvement point.',
    ];

    return AudioAssistedSectionCard(
      title: '6) Revision and Mastery Checklist',
      subtitle:
          'Repeat this block to transform assisted listening into independent recitation quality.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < AudioAssistedLearningData.revision.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _RevisionCard(
                index: i + 1,
                item: AudioAssistedLearningData.revision[i],
              ),
            ),
          const SizedBox(height: 6),
          for (final item in mastery)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      size: 16,
                      color: Color(0xFF1F8B4C),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RevisionCard extends StatelessWidget {
  const _RevisionCard({required this.index, required this.item});

  final int index;
  final AudioRevisionGuide item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
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
                  item.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(item.action, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'audio_assisted_learning_data.dart';
import 'audio_assisted_section_card.dart';

// Section 2: Focused listening drill section.
class AudioAssistedListeningSection extends StatelessWidget {
  const AudioAssistedListeningSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const AudioAssistedSectionCard(
      title: '1) Focused Listening Drills',
      subtitle:
          'Train your ear before speaking so imitation and correction become easier.',
      child: _ListeningDrillList(),
    );
  }
}

class _ListeningDrillList extends StatelessWidget {
  const _ListeningDrillList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in AudioAssistedLearningData.listeningDrills)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ListeningCard(item: item),
          ),
      ],
    );
  }
}

class _ListeningCard extends StatelessWidget {
  const _ListeningCard({required this.item});

  final AudioListeningDrillGuide item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: colorScheme.secondary.withValues(alpha: 0.09),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          _Line(label: 'Goal', value: item.goal),
          const SizedBox(height: 4),
          for (var i = 0; i < item.steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${i + 1}.',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.steps[i],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 3),
          _Line(label: 'Success marker', value: item.successMarker),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodySmall,
        children: [
          TextSpan(
            text: '$label: ',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

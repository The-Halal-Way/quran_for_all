import 'package:flutter/material.dart';

import 'pronunciation_basics_learning_data.dart';
import 'pronunciation_basics_section_card.dart';

// Section 3: Articulation and posture indicators.
class PronunciationBasicsPostureSection extends StatelessWidget {
  const PronunciationBasicsPostureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const PronunciationBasicsSectionCard(
      title: '2) Articulation and Posture Indicators',
      subtitle:
          'Use these indicators while reciting so your sound source remains stable.',
      child: _PostureList(),
    );
  }
}

class _PostureList extends StatelessWidget {
  const _PostureList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final cue in PronunciationBasicsLearningData.postureCues)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _PostureCard(cue: cue),
          ),
      ],
    );
  }
}

class _PostureCard extends StatelessWidget {
  const _PostureCard({required this.cue});

  final PronunciationPostureGuide cue;

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
          Row(
            children: [
              const Icon(Icons.tune_rounded, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  cue.focus,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            'Indicator: ${cue.indicator}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Do: ${cue.doThis}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 3),
          Text(
            'Avoid: ${cue.avoidThis}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

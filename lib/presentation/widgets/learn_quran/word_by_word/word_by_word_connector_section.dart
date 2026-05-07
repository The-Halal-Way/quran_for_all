import 'package:flutter/material.dart';

import 'word_by_word_learning_data.dart';
import 'word_by_word_section_card.dart';

// Section 4: Connector words and phrase role reading.
class WordByWordConnectorSection extends StatelessWidget {
  const WordByWordConnectorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const WordByWordSectionCard(
      title: '3) Connector Words and Particle Cues',
      subtitle:
          'Spot linking words that shape sentence meaning, sequence, emphasis, and direction.',
      child: _ConnectorList(),
    );
  }
}

class _ConnectorList extends StatelessWidget {
  const _ConnectorList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in WordByWordLearningData.connectors)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ConnectorCard(item: item),
          ),
      ],
    );
  }
}

class _ConnectorCard extends StatelessWidget {
  const _ConnectorCard({required this.item});

  final WordByWordConnectorGuide item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: colorScheme.primary.withValues(alpha: 0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.word,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          _Line(label: 'Function', value: item.function),
          const SizedBox(height: 4),
          _Line(label: 'Sample', value: item.sample),
          const SizedBox(height: 4),
          _Line(label: 'Reading cue', value: item.readingCue),
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

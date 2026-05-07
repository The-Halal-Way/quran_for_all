import 'package:flutter/material.dart';

import 'makharij_learning_data.dart';
import 'makharij_section_card.dart';

class MakharijComparisonSection extends StatelessWidget {
  const MakharijComparisonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const MakharijSectionCard(
      title: '2) Confusion Pair Corrections',
      subtitle:
          'Use pair comparisons to protect articulation identity under real recitation pace.',
      child: _ComparisonList(),
    );
  }
}

class _ComparisonList extends StatelessWidget {
  const _ComparisonList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in MakharijLearningData.comparisons)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ComparisonCard(item: item),
          ),
      ],
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({required this.item});

  final MakharijComparisonGuide item;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.pair,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          _Line(label: 'Distinction', value: item.distinction),
          const SizedBox(height: 4),
          _Line(label: 'Practice', value: item.practice),
          const SizedBox(height: 4),
          _Line(label: 'Watch for', value: item.watchFor),
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

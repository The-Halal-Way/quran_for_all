import 'package:flutter/material.dart';

import 'tajweed_learning_data.dart';
import 'tajweed_section_card.dart';

// Section 5: Waqf and restart handling.
class TajweedWaqfSection extends StatelessWidget {
  const TajweedWaqfSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const TajweedSectionCard(
      title: '4) Waqf and Restart Rules',
      subtitle:
          'Practice safe stopping points and clean restarts to preserve meaning and tajweed quality.',
      child: _WaqfList(),
    );
  }
}

class _WaqfList extends StatelessWidget {
  const _WaqfList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in TajweedLearningData.waqf)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _WaqfCard(item: item),
          ),
      ],
    );
  }
}

class _WaqfCard extends StatelessWidget {
  const _WaqfCard({required this.item});

  final TajweedWaqfGuide item;

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
            item.rule,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          _Line(label: 'Pause', value: item.pauseAction),
          const SizedBox(height: 4),
          _Line(label: 'Restart', value: item.restartAction),
          const SizedBox(height: 4),
          _Line(label: 'Example', value: item.example),
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

import 'package:flutter/material.dart';

import 'short_surah_learning_data.dart';
import 'short_surah_section_card.dart';

// Section 3: Tajweed focus points for short surah recitation.
class ShortSurahTajweedFocusSection extends StatelessWidget {
  const ShortSurahTajweedFocusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShortSurahSectionCard(
      title: '2) Tajweed Focus by Surah Type',
      subtitle:
          'Train the most common recitation errors found in short surah practice.',
      child: _TajweedFocusList(),
    );
  }
}

class _TajweedFocusList extends StatelessWidget {
  const _TajweedFocusList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in ShortSurahLearningData.tajweedFocus)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _TajweedCard(item: item),
          ),
      ],
    );
  }
}

class _TajweedCard extends StatelessWidget {
  const _TajweedCard({required this.item});

  final ShortSurahTajweedFocusGuide item;

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
            item.focus,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          _Line(label: 'Rule', value: item.rule),
          const SizedBox(height: 4),
          _Line(label: 'Drill', value: item.drill),
          const SizedBox(height: 4),
          _Line(label: 'Common mistake', value: item.commonMistake),
          const SizedBox(height: 4),
          _Line(label: 'Correction', value: item.correction),
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

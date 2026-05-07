import 'package:flutter/material.dart';

import 'word_by_word_learning_data.dart';
import 'word_by_word_section_card.dart';

// Section 6: Ayah-level word map practice.
class WordByWordAyahMapSection extends StatelessWidget {
  const WordByWordAyahMapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const WordByWordSectionCard(
      title: '5) Ayah Word Map Practice',
      subtitle:
          'Apply vocabulary and connector awareness to complete ayah passages.',
      child: _AyahPracticeList(),
    );
  }
}

class _AyahPracticeList extends StatelessWidget {
  const _AyahPracticeList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in WordByWordLearningData.ayahPractice)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _AyahPracticeCard(item: item),
          ),
      ],
    );
  }
}

class _AyahPracticeCard extends StatelessWidget {
  const _AyahPracticeCard({required this.item});

  final WordByWordAyahPracticeGuide item;

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
            item.reference,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            item.arabic,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 3),
          Text(
            item.transliteration,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          _Line(label: 'Focus', value: item.focus),
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

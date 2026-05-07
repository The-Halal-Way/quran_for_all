import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import 'word_by_word_learning_data.dart';
import 'word_by_word_section_card.dart';

// Section 3: Root-family awareness and recognition.
class WordByWordRootFamilySection extends StatelessWidget {
  const WordByWordRootFamilySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const WordByWordSectionCard(
      title: '2) Root Family Mapping',
      subtitle:
          'Recognize core roots so unfamiliar words still reveal approximate meaning.',
      child: _RootList(),
    );
  }
}

class _RootList extends StatelessWidget {
  const _RootList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in WordByWordLearningData.roots)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _RootCard(item: item),
          ),
      ],
    );
  }
}

class _RootCard extends StatelessWidget {
  const _RootCard({required this.item});

  final WordByWordRootGuide item;

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
            item.root,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          _Line(label: context.learnText('Family'), value: item.family),
          const SizedBox(height: 4),
          _Line(
            label: context.learnText('Core meaning'),
            value: item.coreMeaning,
          ),
          const SizedBox(height: 4),
          _Line(label: context.learnText('Examples'), value: item.examples),
          const SizedBox(height: 4),
          _Line(label: context.learnText('Tip'), value: item.tip),
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

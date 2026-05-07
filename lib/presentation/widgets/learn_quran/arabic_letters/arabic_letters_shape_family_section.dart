import 'package:flutter/material.dart';

import 'arabic_letters_learning_data.dart';
import 'arabic_letters_section_card.dart';

// Section 3: Grouped shape families.
class ArabicLettersShapeFamilySection extends StatelessWidget {
  const ArabicLettersShapeFamilySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ArabicLettersSectionCard(
      title: '2) Grouped Shape Learning',
      subtitle:
          'Learn high-retention groups so you can decode letters quickly during reading.',
      child: _ShapeFamilyList(),
    );
  }
}

class _ShapeFamilyList extends StatelessWidget {
  const _ShapeFamilyList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final family in ArabicLettersLearningData.shapeFamilies)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _FamilyCard(family: family),
          ),
      ],
    );
  }
}

class _FamilyCard extends StatelessWidget {
  const _FamilyCard({required this.family});

  final LetterFamilyGuide family;

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
            family.title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(family.goal, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final letter in family.letters)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    letter,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Tip: ${family.tip}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
    );
  }
}

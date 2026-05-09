import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'arabic_letters_learning_data.dart';
import 'arabic_letters_section_card.dart';

// Section 6: Harakah and sukoon pattern training.
class ArabicLettersHarakahSection extends StatelessWidget {
  const ArabicLettersHarakahSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ArabicLettersSectionCard(
      title: '5) Harakat and Sukoon Pattern Practice',
      subtitle:
          'Read each row slowly. Keep vowel quality stable: fatha (a), kasra (i), damma (u), sukoon (no vowel).',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _HintPill(label: 'Fatha = short a'),
              _HintPill(label: 'Kasra = short i'),
              _HintPill(label: 'Damma = short u'),
              _HintPill(label: 'Sukoon = stop/closed'),
            ],
          ),
          const SizedBox(height: 10),
          for (final pattern in ArabicLettersLearningData.harakahPatterns)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _HarakahPatternCard(pattern: pattern),
            ),
        ],
      ),
    );
  }
}

class _HintPill extends StatelessWidget {
  const _HintPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        color: colorScheme.primary.withValues(alpha: 0.1),
      ),
      child: Text(
        context.learnText(label),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _HarakahPatternCard extends StatelessWidget {
  const _HarakahPatternCard({required this.pattern});

  final HarakahPatternGuide pattern;

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
            context.learnText('Base letter'),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            pattern.baseLetter,
            style: AppTextStyles.learnArabicLetter(
              context,
              fontSize: 30,
            ).copyWith(color: colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HarakahValueChip(title: 'Fatha', value: pattern.fatha),
              _HarakahValueChip(title: 'Kasra', value: pattern.kasra),
              _HarakahValueChip(title: 'Damma', value: pattern.damma),
              _HarakahValueChip(title: 'Sukoon', value: pattern.sukoon),
            ],
          ),
        ],
      ),
    );
  }
}

class _HarakahValueChip extends StatelessWidget {
  const _HarakahValueChip({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(minWidth: 68),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorScheme.secondary.withValues(alpha: 0.09),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.learnText(title),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.learnArabicWord(
              context,
              fontSize: 26,
            ).copyWith(color: colorScheme.primary, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

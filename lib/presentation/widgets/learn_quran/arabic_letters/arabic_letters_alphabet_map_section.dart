import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../pronunciation_button.dart';
import 'arabic_letters_learning_data.dart';
import 'arabic_letters_section_card.dart';

// Section 2: Full alphabet map in isolated forms.
class ArabicLettersAlphabetMapSection extends StatelessWidget {
  const ArabicLettersAlphabetMapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ArabicLettersSectionCard(
      title: '1) Full Alphabet Map (Isolated Forms)',
      subtitle:
          'Start by mastering isolated letters. Read each symbol, then say its name and sound value.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final columns = maxWidth >= 900
              ? 6
              : maxWidth >= 700
              ? 5
              : maxWidth >= 500
              ? 4
              : 3;
          final tileWidth = (maxWidth - ((columns - 1) * 8)) / columns;

          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final letter in ArabicLettersLearningData.alphabet)
                SizedBox(
                  width: tileWidth,
                  child: _AlphabetTile(letter: letter),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _AlphabetTile extends StatelessWidget {
  const _AlphabetTile({required this.letter});

  final ArabicLetterGuide letter;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.18)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PronunciationButton(
                arabicText: letter.symbol,
                size: 18,
                color: colorScheme.primary,
              ),
            ],
          ),
          Text(
            letter.symbol,
            style: AppTextStyles.learnArabicLetter(
              context,
            ).copyWith(fontWeight: FontWeight.w700, color: colorScheme.primary),
          ),
          const SizedBox(height: 2),
          Text(
            letter.name,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            letter.transliteration,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            letter.visualCue,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.74),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

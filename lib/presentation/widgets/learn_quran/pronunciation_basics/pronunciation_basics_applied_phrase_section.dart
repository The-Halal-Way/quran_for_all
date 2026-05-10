import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../pronunciation_button.dart';
import 'pronunciation_basics_learning_data.dart';
import 'pronunciation_basics_section_card.dart';

// Section 7: Applied phrase practice.
class PronunciationBasicsAppliedPhraseSection extends StatelessWidget {
  const PronunciationBasicsAppliedPhraseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const PronunciationBasicsSectionCard(
      title: '6) Applied Phrase Practice',
      subtitle:
          'Use short Quran phrases to combine contrasts, madd, and pause control in context.',
      child: _PhraseList(),
    );
  }
}

class _PhraseList extends StatelessWidget {
  const _PhraseList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final phrase in PronunciationBasicsLearningData.appliedPhrases)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _PhraseCard(phrase: phrase),
          ),
      ],
    );
  }
}

class _PhraseCard extends StatelessWidget {
  const _PhraseCard({required this.phrase});

  final AppliedPhraseGuide phrase;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: colorScheme.secondary.withValues(alpha: 0.08),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  phrase.arabic,
                  style: AppTextStyles.learnArabicWord(context, fontSize: 32)
                      .copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  phrase.transliteration,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  phrase.focus,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          PronunciationButton(
            arabicText: phrase.arabic,
            size: 22,
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

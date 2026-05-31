import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';

import '../../../../core/theme/app_theme.dart';
import '../pronunciation_button.dart';
import 'arabic_letters_learning_data.dart';
import 'arabic_letters_section_card.dart';

// Section 7: Beginner reading examples.
class ArabicLettersReadingExamplesSection extends StatelessWidget {
  const ArabicLettersReadingExamplesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ArabicLettersSectionCard(
      title: '6) Example-Based Beginner Reading Cards',
      subtitle:
          'These words reinforce letters, vowels, and stops used in early Quran recitation.',
      child: _ReadingExampleList(),
    );
  }
}

class _ReadingExampleList extends StatelessWidget {
  const _ReadingExampleList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final example in ArabicLettersLearningData.readingExamples)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ReadingExampleCard(example: example),
          ),
      ],
    );
  }
}

class _ReadingExampleCard extends StatelessWidget {
  const _ReadingExampleCard({required this.example});

  final ReadingExampleGuide example;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.base),
        color: colorScheme.tertiary.withValues(alpha: 0.09),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  example.arabic,
                  style:
                      AppTheme.learnArabicWord(
                        context,
                        fontSize: AppTheme.scaledFontSize(context, 32),
                      ).copyWith(
                        color: colorScheme.primary,
                        fontWeight: AppTheme.weightExtraBold,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  example.transliteration,
                  style: AppTheme.text(
                    context,
                  ).labelLarge.copyWith(fontWeight: AppTheme.weightBold),
                ),
                const SizedBox(height: 4),
                Text(example.focus, style: AppTheme.text(context).bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          PronunciationButton(
            arabicText: example.arabic,
            size: 22,
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

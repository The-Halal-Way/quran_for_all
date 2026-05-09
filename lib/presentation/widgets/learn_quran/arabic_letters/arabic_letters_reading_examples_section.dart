import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
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
        borderRadius: BorderRadius.circular(14),
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
                  style: AppTextStyles.learnArabicWord(context, fontSize: 32)
                      .copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  example.transliteration,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  example.focus,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.menu_book_rounded, color: colorScheme.primary),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../pronunciation_button.dart';
import 'word_by_word_learning_data.dart';
import 'word_by_word_section_card.dart';

// Section 2: High-frequency vocabulary bank.
class WordByWordVocabularySection extends StatelessWidget {
  const WordByWordVocabularySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const WordByWordSectionCard(
      title: '1) High-Frequency Vocabulary Bank',
      subtitle:
          'Memorize recurring Quran words so ayah meaning becomes easier to follow in real time.',
      child: _VocabularyGrid(),
    );
  }
}

class _VocabularyGrid extends StatelessWidget {
  const _VocabularyGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final columns = maxWidth >= 900
            ? 3
            : maxWidth >= 620
            ? 2
            : 1;
        final width = (maxWidth - ((columns - 1) * 8)) / columns;

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final item in WordByWordLearningData.coreVocabulary)
              SizedBox(
                width: width,
                child: _VocabCard(item: item),
              ),
          ],
        );
      },
    );
  }
}

class _VocabCard extends StatelessWidget {
  const _VocabCard({required this.item});

  final WordByWordVocabGuide item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: colorScheme.secondary.withValues(alpha: 0.09),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.arabic,
                  style:
                      AppTheme.learnArabicWord(
                        context,
                        fontSize: AppTheme.scaledFontSize(context, 31),
                      ).copyWith(
                        color: colorScheme.primary,
                        fontWeight: AppTheme.weightExtraBold,
                      ),
                ),
              ),
              PronunciationButton(
                arabicText: item.arabic,
                size: 20,
                color: colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            item.transliteration,
            style: AppTheme.text(
              context,
            ).labelLarge.copyWith(fontWeight: AppTheme.weightBold),
          ),
          const SizedBox(height: 4),
          Text(
            item.meaning,
            style: AppTheme.text(
              context,
            ).bodyMedium.copyWith(fontWeight: AppTheme.weightBold),
          ),
          const SizedBox(height: 4),
          Text(item.usage, style: AppTheme.text(context).bodySmall),
        ],
      ),
    );
  }
}

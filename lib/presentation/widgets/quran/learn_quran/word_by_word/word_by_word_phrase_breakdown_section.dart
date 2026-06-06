import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../pronunciation_button.dart';
import 'word_by_word_learning_data.dart';
import 'word_by_word_section_card.dart';

// Section 5: Phrase-by-phrase meaning breakdown.
class WordByWordPhraseBreakdownSection extends StatelessWidget {
  const WordByWordPhraseBreakdownSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const WordByWordSectionCard(
      title: '4) Phrase Breakdown Lab',
      subtitle:
          'Break phrases into word units, then reconnect them into complete meaning.',
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
        for (final item in WordByWordLearningData.phraseBreakdowns)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _PhraseCard(item: item),
          ),
      ],
    );
  }
}

class _PhraseCard extends StatelessWidget {
  const _PhraseCard({required this.item});

  final WordByWordPhraseGuide item;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        fontWeight: AppTheme.weightBold,
                      ),
                ),
              ),
              PronunciationButton(
                arabicText: item.arabic,
                size: 22,
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
          const SizedBox(height: 6),
          _Line(label: context.learnText('Word map'), value: item.breakdown),
          const SizedBox(height: 4),
          _Line(label: context.learnText('Meaning'), value: item.meaning),
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
        style: AppTheme.text(context).bodySmall,
        children: [
          TextSpan(
            text: '$label: ',
            style: AppTheme.text(
              context,
            ).labelMedium.copyWith(fontWeight: AppTheme.weightBold),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

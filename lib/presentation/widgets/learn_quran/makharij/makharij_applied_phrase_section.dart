import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../pronunciation_button.dart';
import 'makharij_learning_data.dart';
import 'makharij_section_card.dart';

class MakharijAppliedPhraseSection extends StatelessWidget {
  const MakharijAppliedPhraseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const MakharijSectionCard(
      title: '4) Applied Phrase Practice',
      subtitle:
          'Apply makharij precision in short Quran phrases so articulation remains clear in context.',
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
        for (final phrase in MakharijLearningData.phrases)
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

  final MakharijPhraseGuide phrase;

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
                  style:
                      AppTheme.learnArabicWord(
                        context,
                        fontSize: AppTheme.scaledFontSize(context, 32),
                      ).copyWith(
                        fontWeight: AppTheme.weightBold,
                        color: colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  phrase.transliteration,
                  style: AppTheme.text(
                    context,
                  ).labelLarge.copyWith(fontWeight: AppTheme.weightBold),
                ),
                const SizedBox(height: 4),
                Text(phrase.focus, style: AppTheme.text(context).bodySmall),
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

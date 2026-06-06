import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../pronunciation_button.dart';
import 'word_by_word_learning_data.dart';
import 'word_by_word_section_card.dart';

// Section 6: Ayah-level word map practice.
class WordByWordAyahMapSection extends StatelessWidget {
  const WordByWordAyahMapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const WordByWordSectionCard(
      title: '5) Ayah Word Map Practice',
      subtitle:
          'Apply vocabulary and connector awareness to complete ayah passages.',
      child: _AyahPracticeList(),
    );
  }
}

class _AyahPracticeList extends StatelessWidget {
  const _AyahPracticeList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in WordByWordLearningData.ayahPractice)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _AyahPracticeCard(item: item),
          ),
      ],
    );
  }
}

class _AyahPracticeCard extends StatelessWidget {
  const _AyahPracticeCard({required this.item});

  final WordByWordAyahPracticeGuide item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.base),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.reference,
            style: AppTheme.text(context).titleSmall.copyWith(
              color: colorScheme.primary,
              fontWeight: AppTheme.weightExtraBold,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.arabic,
                  style: AppTheme.learnArabicWord(
                    context,
                    fontSize: AppTheme.scaledFontSize(context, 29),
                  ).copyWith(fontWeight: AppTheme.weightBold),
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
          _Line(label: context.learnText('Focus'), value: item.focus),
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

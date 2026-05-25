import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../pronunciation_button.dart';
import 'short_surah_learning_data.dart';
import 'short_surah_section_card.dart';

// Section 6: Meaning-linked recitation practice.
class ShortSurahMeaningLinkSection extends StatelessWidget {
  const ShortSurahMeaningLinkSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShortSurahSectionCard(
      title: '5) Meaning-Linked Recitation',
      subtitle:
          'Tie ayah message to your voice so recitation is not only correct, but understood.',
      child: _MeaningLinkList(),
    );
  }
}

class _MeaningLinkList extends StatelessWidget {
  const _MeaningLinkList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in ShortSurahLearningData.meaningLink)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _MeaningCard(item: item),
          ),
      ],
    );
  }
}

class _MeaningCard extends StatelessWidget {
  const _MeaningCard({required this.item});

  final ShortSurahMeaningLinkGuide item;

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
          _Line(label: context.learnText('Message'), value: item.message),
          const SizedBox(height: 4),
          _Line(
            label: context.learnText('Recitation cue'),
            value: item.recitationCue,
          ),
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

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../pronunciation_button.dart';
import 'arabic_letters_learning_data.dart';
import 'arabic_letters_section_card.dart';

// Section 4: Similar-letter comparison grid.
class ArabicLettersSimilarLettersSection extends StatelessWidget {
  const ArabicLettersSimilarLettersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ArabicLettersSectionCard(
      title: '3) Similar Letter Comparison Grid',
      subtitle:
          'Use this as your anti-confusion reference. Compare shape and sound before speed.',
      child: _ComparisonList(),
    );
  }
}

class _ComparisonList extends StatelessWidget {
  const _ComparisonList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final guide in ArabicLettersLearningData.comparisons)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ComparisonCard(guide: guide),
          ),
      ],
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({required this.guide});

  final SimilarLetterGuide guide;

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
          Row(
            children: [
              Expanded(
                child: Text(
                  guide.letters,
                  style:
                      AppTheme.learnArabicWord(
                        context,
                        fontSize: AppTheme.scaledFontSize(context, 28),
                      ).copyWith(
                        color: colorScheme.primary,
                        fontWeight: AppTheme.weightExtraBold,
                      ),
                ),
              ),
              PronunciationButton(
                arabicText: guide.practice,
                size: 20,
                color: colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 6),
          _Line(
            label: context.learnText('Difference'),
            value: guide.differenceRule,
          ),
          const SizedBox(height: 4),
          _Line(label: context.learnText('Practice'), value: guide.practice),
          const SizedBox(height: 4),
          _Line(
            label: context.learnText('Watch for'),
            value: guide.commonMistake,
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

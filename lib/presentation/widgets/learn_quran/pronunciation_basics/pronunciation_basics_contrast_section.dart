import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../pronunciation_button.dart';
import 'pronunciation_basics_learning_data.dart';
import 'pronunciation_basics_section_card.dart';

// Section 2: Heavy vs light contrast training.
class PronunciationBasicsContrastSection extends StatelessWidget {
  const PronunciationBasicsContrastSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const PronunciationBasicsSectionCard(
      title: '1) Heavy vs Light Contrast Grid',
      subtitle:
          'Train contrasts before speed. Correct distinction here prevents long-term pronunciation errors.',
      child: _ContrastList(),
    );
  }
}

class _ContrastList extends StatelessWidget {
  const _ContrastList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in PronunciationBasicsLearningData.contrasts)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ContrastCard(item: item),
          ),
      ],
    );
  }
}

class _ContrastCard extends StatelessWidget {
  const _ContrastCard({required this.item});

  final PronunciationContrastGuide item;

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
                  item.pair,
                  style: AppTheme.text(context).titleSmall.copyWith(
                    color: colorScheme.primary,
                    fontWeight: AppTheme.weightExtraBold,
                  ),
                ),
              ),
              PronunciationButton(
                arabicText: item.pair.replaceAll(' / ', ' '),
                size: 20,
                color: colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 6),
          _Line(
            label: context.learnText('Light sample'),
            value: item.lightExample,
          ),
          const SizedBox(height: 4),
          _Line(
            label: context.learnText('Heavy sample'),
            value: item.heavyExample,
          ),
          const SizedBox(height: 4),
          _Line(
            label: context.learnText('Difference'),
            value: item.keyDifference,
          ),
          const SizedBox(height: 4),
          _Line(label: context.learnText('Coach tip'), value: item.coachTip),
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

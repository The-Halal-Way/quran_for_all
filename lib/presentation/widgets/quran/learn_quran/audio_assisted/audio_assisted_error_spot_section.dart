import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import 'audio_assisted_learning_data.dart';
import 'audio_assisted_section_card.dart';

// Section 4: Error spotting and correction map.
class AudioAssistedErrorSpotSection extends StatelessWidget {
  const AudioAssistedErrorSpotSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const AudioAssistedSectionCard(
      title: '3) Error Spot and Fix Map',
      subtitle:
          'Use structured checks to detect recurring mistakes and apply targeted corrections.',
      child: _ErrorSpotList(),
    );
  }
}

class _ErrorSpotList extends StatelessWidget {
  const _ErrorSpotList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in AudioAssistedLearningData.errorSpotting)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ErrorSpotCard(item: item),
          ),
      ],
    );
  }
}

class _ErrorSpotCard extends StatelessWidget {
  const _ErrorSpotCard({required this.item});

  final AudioErrorSpotGuide item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.base),
        color: colorScheme.primary.withValues(alpha: 0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.category,
            style: AppTheme.text(context).titleSmall.copyWith(
              color: colorScheme.primary,
              fontWeight: AppTheme.weightExtraBold,
            ),
          ),
          const SizedBox(height: 5),
          _Line(
            label: context.learnText('Check prompt'),
            value: item.checkPrompt,
          ),
          const SizedBox(height: 4),
          _Line(
            label: context.learnText('Common signs'),
            value: item.commonSigns,
          ),
          const SizedBox(height: 4),
          _Line(label: context.learnText('Fix'), value: item.fix),
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

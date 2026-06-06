import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import 'pronunciation_basics_learning_data.dart';
import 'pronunciation_basics_section_card.dart';

// Section 3: Articulation and posture indicators.
class PronunciationBasicsPostureSection extends StatelessWidget {
  const PronunciationBasicsPostureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const PronunciationBasicsSectionCard(
      title: '2) Articulation and Posture Indicators',
      subtitle:
          'Use these indicators while reciting so your sound source remains stable.',
      child: _PostureList(),
    );
  }
}

class _PostureList extends StatelessWidget {
  const _PostureList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final cue in PronunciationBasicsLearningData.postureCues)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _PostureCard(cue: cue),
          ),
      ],
    );
  }
}

class _PostureCard extends StatelessWidget {
  const _PostureCard({required this.cue});

  final PronunciationPostureGuide cue;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.base),
        color: colorScheme.secondary.withValues(alpha: 0.09),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune_rounded, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  cue.focus,
                  style: AppTheme.text(
                    context,
                  ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            '${context.learnText('Indicator')}: ${cue.indicator}',
            style: AppTheme.text(context).labelMedium.copyWith(
              color: colorScheme.primary,
              fontWeight: AppTheme.weightBold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${context.learnText('Do')}: ${cue.doThis}',
            style: AppTheme.text(context).bodySmall,
          ),
          const SizedBox(height: 3),
          Text(
            '${context.learnText('Avoid')}: ${cue.avoidThis}',
            style: AppTheme.text(context).bodySmall.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

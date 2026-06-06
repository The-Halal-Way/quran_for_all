import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import 'pronunciation_basics_learning_data.dart';
import 'pronunciation_basics_section_card.dart';

// Section 6: Rhythm and flow drills.
class PronunciationBasicsFlowDrillSection extends StatelessWidget {
  const PronunciationBasicsFlowDrillSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const PronunciationBasicsSectionCard(
      title: '5) Rhythm and Flow Drills',
      subtitle:
          'These drills join pronunciation with rhythm so clarity remains under continuous reading.',
      child: _FlowDrillList(),
    );
  }
}

class _FlowDrillList extends StatelessWidget {
  const _FlowDrillList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final drill in PronunciationBasicsLearningData.flowDrills)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _FlowDrillCard(drill: drill),
          ),
      ],
    );
  }
}

class _FlowDrillCard extends StatelessWidget {
  const _FlowDrillCard({required this.drill});

  final FlowDrillGuide drill;

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
            drill.title,
            style: AppTheme.text(
              context,
            ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
          ),
          const SizedBox(height: 6),
          for (var index = 0; index < drill.steps.length; index++)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}.',
                    style: AppTheme.text(context).labelMedium,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      drill.steps[index],
                      style: AppTheme.text(context).bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 3),
          Text(
            '${context.learnText('Goal')}: ${drill.goal}',
            style: AppTheme.text(context).labelMedium.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
    );
  }
}

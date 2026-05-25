import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../core/localization/l10n_extensions.dart';
import 'makharij_learning_data.dart';
import 'makharij_section_card.dart';

class MakharijDrillsSection extends StatelessWidget {
  const MakharijDrillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const MakharijSectionCard(
      title: '3) Guided Makharij Drills',
      subtitle:
          'These structured drills build consistency from isolated letters into connected delivery.',
      child: _DrillList(),
    );
  }
}

class _DrillList extends StatelessWidget {
  const _DrillList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final drill in MakharijLearningData.drills)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _DrillCard(drill: drill),
          ),
      ],
    );
  }
}

class _DrillCard extends StatelessWidget {
  const _DrillCard({required this.drill});

  final MakharijDrillGuide drill;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
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
          for (var i = 0; i < drill.steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${i + 1}.', style: AppTheme.text(context).labelMedium),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      drill.steps[i],
                      style: AppTheme.text(context).bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 3),
          Text(
            '${context.learnText('Target')}: ${drill.target}',
            style: AppTheme.text(context).labelMedium.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
    );
  }
}

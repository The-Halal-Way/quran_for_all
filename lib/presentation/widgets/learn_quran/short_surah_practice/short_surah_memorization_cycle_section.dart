import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../core/localization/l10n_extensions.dart';
import 'short_surah_learning_data.dart';
import 'short_surah_section_card.dart';

// Section 4: Structured memorization cycle.
class ShortSurahMemorizationCycleSection extends StatelessWidget {
  const ShortSurahMemorizationCycleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShortSurahSectionCard(
      title: '3) Memorization Cycle Routine',
      subtitle:
          'Use this timed cycle to improve retention without sacrificing pronunciation quality.',
      child: _CycleList(),
    );
  }
}

class _CycleList extends StatelessWidget {
  const _CycleList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (
          var i = 0;
          i < ShortSurahLearningData.memorizationCycle.length;
          i++
        )
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _CycleCard(
              index: i + 1,
              item: ShortSurahLearningData.memorizationCycle[i],
            ),
          ),
      ],
    );
  }
}

class _CycleCard extends StatelessWidget {
  const _CycleCard({required this.index, required this.item});

  final int index;
  final ShortSurahMemorizationCycleGuide item;

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
            child: Text(
              '$index',
              style: AppTheme.text(context).labelMedium.copyWith(
                color: colorScheme.primary,
                fontWeight: AppTheme.weightExtraBold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.phase,
                  style: AppTheme.text(
                    context,
                  ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
                ),
                const SizedBox(height: 4),
                Text(item.action, style: AppTheme.text(context).bodySmall),
                const SizedBox(height: 4),
                Text(
                  '${context.learnText('Duration')}: ${item.duration}',
                  style: AppTheme.text(context).labelMedium.copyWith(
                    color: colorScheme.primary,
                    fontWeight: AppTheme.weightBold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${context.learnText('Goal')}: ${item.goal}',
                  style: AppTheme.text(context).bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

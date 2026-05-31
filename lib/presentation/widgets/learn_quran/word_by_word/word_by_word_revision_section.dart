import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../core/localization/l10n_extensions.dart';
import 'word_by_word_learning_data.dart';
import 'word_by_word_section_card.dart';

// Section 7: Revision and mastery checklist.
class WordByWordRevisionSection extends StatelessWidget {
  const WordByWordRevisionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final mastery = <String>[
      'I can recognize at least 20 high-frequency Quran words quickly.',
      'I can infer general meaning from common root families.',
      'I can identify connector particles and their phrase role.',
      'I can break a short ayah into word groups with translation awareness.',
      'I can summarize one short surah in simple meaning-based notes.',
    ];

    return WordByWordSectionCard(
      title: '6) Revision and Mastery Checklist',
      subtitle:
          'Use this cycle to shift from memorizing isolated words to understanding recitation meaning.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < WordByWordLearningData.revision.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _RevisionCard(
                index: i + 1,
                item: WordByWordLearningData.revision[i],
              ),
            ),
          const SizedBox(height: 6),
          for (final item in mastery)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      size: 16,
                      color: Color(0xFF1F8B4C),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      context.learnText(item),
                      style: AppTheme.text(context).bodySmall,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RevisionCard extends StatelessWidget {
  const _RevisionCard({required this.index, required this.item});

  final int index;
  final WordByWordRevisionGuide item;

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: colorScheme.primary.withValues(alpha: 0.14),
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
                  item.title,
                  style: AppTheme.text(
                    context,
                  ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
                ),
                const SizedBox(height: 3),
                Text(item.action, style: AppTheme.text(context).bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

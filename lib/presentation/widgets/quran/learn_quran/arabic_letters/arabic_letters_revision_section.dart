import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import 'arabic_letters_learning_data.dart';
import 'arabic_letters_section_card.dart';

// Section 8: Revision and mastery checklist.
class ArabicLettersRevisionSection extends StatelessWidget {
  const ArabicLettersRevisionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final checkpoints = <String>[
      'I can name and identify all 29 letters in isolated form.',
      'I can separate look-alike letters by dot count and position.',
      'I can produce basic throat, tongue, and lip letters with control.',
      'I can read fatha, kasra, damma, and sukoon patterns aloud.',
      'I can read beginner examples without adding extra vowels.',
    ];

    return ArabicLettersSectionCard(
      title: '7) Guided Review and Mastery Check',
      subtitle:
          'Use this block as your daily 12-minute revision loop until recognition and pronunciation feel natural.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (
            var i = 0;
            i < ArabicLettersLearningData.revisionBlocks.length;
            i++
          )
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _RevisionCard(
                index: i + 1,
                block: ArabicLettersLearningData.revisionBlocks[i],
              ),
            ),
          const SizedBox(height: 4),
          for (final checkpoint in checkpoints)
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
                      context.learnText(checkpoint),
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
  const _RevisionCard({required this.index, required this.block});

  final int index;
  final RevisionBlockGuide block;

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
                  block.title,
                  style: AppTheme.text(
                    context,
                  ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
                ),
                const SizedBox(height: 3),
                Text(block.drill, style: AppTheme.text(context).bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

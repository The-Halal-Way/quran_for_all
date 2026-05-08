import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import 'short_surah_learning_data.dart';
import 'short_surah_section_card.dart';

// Section 7: Revision and mastery validation.
class ShortSurahRevisionSection extends StatelessWidget {
  const ShortSurahRevisionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final mastery = <String>[
      'I can recite at least 4 short surahs without looking at the text.',
      'I can maintain steady pace suitable for salah recitation.',
      'I can apply key tajweed targets inside each short surah.',
      'I can stop and restart at meaningful phrase boundaries.',
      'I can summarize the core message of each practiced surah.',
    ];

    return ShortSurahSectionCard(
      title: '6) Revision and Mastery Checklist',
      subtitle:
          'Use this revision loop to turn short surah memorization into long-term confidence.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < ShortSurahLearningData.revision.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _RevisionCard(
                index: i + 1,
                item: ShortSurahLearningData.revision[i],
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
                      style: Theme.of(context).textTheme.bodySmall,
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
  final ShortSurahRevisionGuide item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
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
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w800,
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
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(item.action, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

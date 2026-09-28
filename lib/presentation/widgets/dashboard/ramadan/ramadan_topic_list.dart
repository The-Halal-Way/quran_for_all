import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../views/dashboard/ramadan/ramadan_models.dart';
import 'ramadan_topic_card.dart';

class RamadanTopicList extends StatelessWidget {
  const RamadanTopicList({
    super.key,
    required this.isBangla,
    required this.title,
    required this.entries,
  });

  final bool isBangla;
  final String title;
  final List<MapEntry<int, RamadanTopic>> entries;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        title,
        style: AppTheme.text(
          context,
        ).titleLarge.copyWith(fontWeight: AppTheme.weightExtraBold),
      ),
      const SizedBox(height: AppSpacing.md),
      if (entries.isEmpty)
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Text(
            ramadanLabel(
              isBangla,
              'No topics found. Try another word.',
              'কোনো বিষয় পাওয়া যায়নি। অন্য শব্দ লিখুন।',
            ),
          ),
        )
      else
        for (final entry in entries)
          RamadanTopicCard(
            key: ValueKey('ramadan_card_${entry.key}'),
            topic: entry.value,
            isBangla: isBangla,
            index: entry.key,
          ),
    ],
  );
}

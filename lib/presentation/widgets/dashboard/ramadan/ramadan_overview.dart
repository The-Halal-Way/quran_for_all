import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../views/dashboard/ramadan/ramadan_content.dart';
import 'ramadan_journey_map.dart';
import 'ramadan_overview_section_tile.dart';
import 'ramadan_section_heading.dart';

class RamadanOverview extends StatelessWidget {
  const RamadanOverview({
    super.key,
    required this.isBangla,
    required this.onSelectSection,
  });

  final bool isBangla;
  final ValueChanged<RamadanSection> onSelectSection;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      RamadanJourneyMap(isBangla: isBangla),
      const SizedBox(height: AppSpacing.xxl),
      RamadanSectionHeading(
        icon: Icons.explore_rounded,
        title: ramadanLabel(isBangla, 'Explore the guide', 'সহায়িকা দেখুন'),
        subtitle: ramadanLabel(
          isBangla,
          'Choose a subject, then open each card for practical steps and its source.',
          'বিষয় বেছে নিয়ে করণীয় ও সূত্র দেখতে কার্ড খুলুন।',
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      for (final section in RamadanSection.values) ...[
        RamadanOverviewSectionTile(
          section: section,
          isBangla: isBangla,
          count: ramadanTopics
              .where((topic) => topic.section == section)
              .length,
          onTap: () => onSelectSection(section),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    ],
  );
}

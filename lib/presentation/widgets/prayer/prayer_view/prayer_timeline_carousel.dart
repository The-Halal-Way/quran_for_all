import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/prayer/prayer_detail_models.dart';
import 'prayer_timeline_tile.dart';

class PrayerTimelineCarousel extends StatelessWidget {
  const PrayerTimelineCarousel({super.key, required this.items});

  final List<PrayerTimelineItem> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 132,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) =>
            SizedBox(width: 132, child: PrayerTimelineTile(item: items[index])),
      ),
    );
  }
}

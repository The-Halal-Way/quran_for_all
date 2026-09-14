import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/prayer/prayer_detail_models.dart';
import 'prayer_timeline_tile.dart';

class PrayerTimelineGrid extends StatelessWidget {
  const PrayerTimelineGrid({super.key, required this.items});

  final List<PrayerTimelineItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final largeText = MediaQuery.textScalerOf(context).scale(14) > 20;
        final columns = largeText || constraints.maxWidth < 320
            ? 1
            : constraints.maxWidth >= 620
            ? 3
            : 2;
        final width =
            (constraints.maxWidth - AppSpacing.sm * (columns - 1)) / columns;
        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final item in items)
              SizedBox(
                width: width,
                child: PrayerTimelineTile(item: item),
              ),
          ],
        );
      },
    );
  }
}

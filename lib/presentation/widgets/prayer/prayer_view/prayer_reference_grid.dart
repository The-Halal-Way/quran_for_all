import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import 'prayer_reference_card.dart';
import 'prayer_reference_item.dart';

class PrayerReferenceGrid extends StatelessWidget {
  const PrayerReferenceGrid({super.key, required this.items});

  final List<PrayerReferenceItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            constraints.maxWidth < 320 ||
                MediaQuery.textScalerOf(context).scale(14) > 20
            ? 1
            : 2;
        return Column(
          children: [
            for (var row = 0; row < items.length; row += columns) ...[
              if (row > 0) const SizedBox(height: AppSpacing.sm),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var column = 0; column < columns; column++) ...[
                      if (column > 0) const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: row + column < items.length
                            ? PrayerReferenceCard(item: items[row + column])
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

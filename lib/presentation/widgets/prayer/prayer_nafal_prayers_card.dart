import 'package:flutter/material.dart';

import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/presentation/widgets/prayer/nafal/nafal_prayer_note.dart';
import 'package:quran_for_all/presentation/widgets/prayer/nafal/nafal_prayer_tile.dart';
import 'package:quran_for_all/presentation/widgets/prayer/nafal/nafal_prayers_header.dart';
import 'package:quran_for_all/presentation/widgets/prayer/shared/prayer_card_shell.dart';

class PrayerNafalPrayersCard extends StatelessWidget {
  const PrayerNafalPrayersCard({super.key, required this.items});

  final List<PrayerNafalPrayerItem> items;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PrayerCardShell(
      padding: EdgeInsets.zero,
      borderColor: MyColors.tertiary.withValues(alpha: 0.32),
      shadowColor: MyColors.tertiary,
      gradient: LinearGradient(
        colors: isDark
            ? const [Color(0xFF071E2C), Color(0xFF21062F), Color(0xFF032D28)]
            : const [Color(0xFFE2FFF9), Color(0xFFF0E7FF), Color(0xFFFFE6F0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NafalPrayersHeader(isDark: isDark),
              const SizedBox(height: AppSpacing.lg),
              LayoutBuilder(
                builder: (context, constraints) {
                  final tileWidth = constraints.maxWidth >= 680
                      ? (constraints.maxWidth - AppSpacing.md) / 2
                      : constraints.maxWidth;

                  return Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      for (var index = 0; index < items.length; index++)
                        SizedBox(
                          width: tileWidth,
                          child: NafalPrayerTile(
                            item: items[index],
                            index: index,
                            isDark: isDark,
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              NafalPrayerNote(isDark: isDark),
            ],
          ),
        ),
      ),
    );
  }
}

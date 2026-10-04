import 'package:flutter/material.dart';

import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/presentation/widgets/prayer/forbidden/forbidden_time_tile.dart';
import 'package:quran_for_all/presentation/widgets/prayer/forbidden/forbidden_times_header.dart';
import 'package:quran_for_all/presentation/widgets/prayer/shared/prayer_card_shell.dart';

class PrayerForbiddenTimesCard extends StatelessWidget {
  const PrayerForbiddenTimesCard({super.key, required this.items});

  final List<PrayerForbiddenTimeItem> items;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PrayerCardShell(
      padding: EdgeInsets.zero,
      borderColor: MyColors.secondary.withValues(alpha: 0.38),
      shadowColor: MyColors.secondary,
      gradient: LinearGradient(
        colors: isDark
            ? const [Color(0xFF2A0532), MyColors.primaryDark, Color(0xFF052722)]
            : const [Color(0xFFFFE1EB), Color(0xFFEAE1FF), Color(0xFFE2FFF9)],
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
              ForbiddenTimesHeader(isDark: isDark),
              const SizedBox(height: AppSpacing.lg),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 680;
                  final tileWidth = wide
                      ? (constraints.maxWidth - AppSpacing.md) / 2
                      : constraints.maxWidth;

                  return Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      for (var index = 0; index < items.length; index++)
                        SizedBox(
                          width: tileWidth,
                          child: ForbiddenTimeTile(
                            item: items[index],
                            index: index,
                            isDark: isDark,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import 'prayer_reference_item.dart';

class PrayerReferenceCard extends StatelessWidget {
  const PrayerReferenceCard({super.key, required this.item});

  final PrayerReferenceItem item;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? MyColors.darkCardFill : Colors.white;

    return Semantics(
      button: true,
      excludeSemantics: true,
      label: '${item.title}. ${item.semanticDescription}',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: item.onTap,
          child: Ink(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: surface,
              border: Border.all(color: item.color.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Icon(item.icon, color: item.color, size: 19),
                    ),
                    const Spacer(),
                    Icon(Icons.north_east_rounded, color: item.color, size: 17),
                  ],
                ),
                const Spacer(),
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.labelMedium.copyWith(
                    fontWeight: AppTheme.weightExtraBold,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

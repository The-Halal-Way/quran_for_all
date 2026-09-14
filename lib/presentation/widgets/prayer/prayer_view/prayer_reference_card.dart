import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import 'prayer_reference_item.dart';

class PrayerReferenceCard extends StatelessWidget {
  const PrayerReferenceCard({
    super.key,
    required this.item,
    this.featured = false,
  });

  final PrayerReferenceItem item;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = featured
        ? MyColors.tertiaryLight
        : isDark
        ? Color.lerp(item.color, Colors.white, 0.45)!
        : item.color;
    final foreground = featured ? Colors.white : colors.onSurface;
    return Semantics(
      button: true,
      excludeSemantics: true,
      label: '${item.title}. ${item.description}',
      onTap: item.onTap,
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            gradient: featured
                ? const LinearGradient(
                    colors: [MyColors.primary, MyColors.primaryLight],
                  )
                : LinearGradient(
                    colors: [
                      colors.surface,
                      Color.lerp(
                        colors.surface,
                        item.color,
                        isDark ? 0.12 : 0.05,
                      )!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: accent.withValues(alpha: 0.18)),
          ),
          child: InkWell(
            onTap: item.onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Icon(
                          item.icon,
                          color: accent,
                          size: featured ? 27 : 22,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: accent,
                        size: 19,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    item.title,
                    style: (featured ? text.titleMedium : text.labelMedium)
                        .copyWith(
                          color: foreground,
                          fontWeight: AppTheme.weightExtraBold,
                          height: 1.4,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    item.description,
                    style: text.bodySmall.copyWith(
                      color: foreground.withValues(alpha: 0.7),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

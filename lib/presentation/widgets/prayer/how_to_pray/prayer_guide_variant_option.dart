import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

class PrayerGuideVariantOption extends StatelessWidget {
  const PrayerGuideVariantOption({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = dark ? MyColors.secondaryLight : MyColors.secondaryDark;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      onTap: onTap,
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? colors.surface
                  : colors.surface.withValues(alpha: 0),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: selected
                    ? accent.withValues(alpha: 0.65)
                    : Colors.transparent,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.1),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: selected ? accent : colors.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    label,
                    style: AppTheme.text(context).labelLarge.copyWith(
                      color: selected
                          ? colors.onSurface
                          : colors.onSurfaceVariant,
                      fontWeight: AppTheme.weightExtraBold,
                    ),
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Icon(Icons.check_circle_rounded, size: 16, color: accent),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

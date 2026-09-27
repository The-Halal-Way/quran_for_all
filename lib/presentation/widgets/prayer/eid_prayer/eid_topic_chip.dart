import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class EidTopicChip extends StatelessWidget {
  const EidTopicChip({
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
    return Semantics(
      button: true,
      selected: selected,
      excludeSemantics: true,
      label: label,
      child: Material(
        color: selected ? colors.primary : colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.full),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(
                color: selected ? colors.primary : colors.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: selected ? colors.onPrimary : colors.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  label,
                  style: AppTheme.text(context).labelMedium.copyWith(
                    color: selected ? colors.onPrimary : colors.onSurface,
                    fontWeight: AppTheme.weightBold,
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

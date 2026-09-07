import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsChoiceSegment<T> extends StatelessWidget {
  const SettingsChoiceSegment({
    super.key,
    required this.value,
    required this.selectedValue,
    required this.label,
    required this.icon,
    required this.accent,
    required this.onSelected,
  });

  final T value;
  final T selectedValue;
  final String label;
  final IconData icon;
  final Color accent;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final selected = value == selectedValue;
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: () => onSelected(value),
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: selected
                  ? accent.withValues(alpha: 0.14)
                  : colorScheme.onSurface.withValues(alpha: 0.035),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: selected
                    ? accent.withValues(alpha: 0.38)
                    : colorScheme.outline.withValues(alpha: 0.12),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: selected
                      ? accent
                      : colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 3),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: AppTheme.text(context).labelSmall.copyWith(
                      color: selected
                          ? accent
                          : colorScheme.onSurface.withValues(alpha: 0.62),
                      fontWeight: AppTheme.weightBold,
                    ),
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

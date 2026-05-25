import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

class TasbeehTargetSelector extends StatelessWidget {
  const TasbeehTargetSelector({
    super.key,
    required this.targets,
    required this.selectedTarget,
    required this.isDark,
    required this.onSelected,
  });

  final List<int> targets;
  final int selectedTarget;
  final bool isDark;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final foreground = isDark ? Colors.white : MyColors.textPrimary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isDark ? MyColors.darkCardFill : Colors.white).withValues(
          alpha: isDark ? 0.86 : 0.92,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isDark ? Colors.white : MyColors.divider).withValues(
            alpha: isDark ? 0.07 : 0.82,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withValues(alpha: isDark ? 0.14 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag_rounded, color: MyColors.tertiary, size: 18),
              const SizedBox(width: 8),
              Text(
                context.l10n.tasbeehTarget,
                style: text.titleSmall.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final target in targets)
                ChoiceChip(
                  label: Text('$target'),
                  selected: selectedTarget == target,
                  selectedColor: MyColors.tertiary.withValues(alpha: 0.22),
                  backgroundColor: foreground.withValues(alpha: 0.05),
                  side: BorderSide(
                    color: selectedTarget == target
                        ? MyColors.tertiary
                        : foreground.withValues(alpha: 0.12),
                  ),
                  labelStyle: text.labelMedium.copyWith(
                    color: selectedTarget == target
                        ? (isDark
                              ? MyColors.tertiaryLight
                              : MyColors.tertiaryDark)
                        : foreground.withValues(alpha: 0.74),
                    fontWeight: FontWeight.w800,
                  ),
                  onSelected: (_) => onSelected(target),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

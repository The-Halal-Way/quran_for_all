import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
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
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: (isDark ? Colors.white : MyColors.divider).withValues(
            alpha: isDark ? 0.07 : 0.82,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(CupertinoIcons.scope, color: MyColors.tertiary, size: 18),
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
          SizedBox(
            width: double.infinity,
            child: CupertinoSlidingSegmentedControl<int>(
              groupValue: selectedTarget,
              backgroundColor: foreground.withValues(alpha: 0.06),
              thumbColor: isDark
                  ? MyColors.tertiaryDark
                  : MyColors.tertiary.withValues(alpha: 0.2),
              children: {
                for (final target in targets)
                  target: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Text(
                      '$target',
                      style: text.labelMedium.copyWith(
                        color: selectedTarget == target
                            ? (isDark ? Colors.white : MyColors.tertiaryDark)
                            : foreground.withValues(alpha: 0.68),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              },
              onValueChanged: (value) {
                if (value != null) onSelected(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

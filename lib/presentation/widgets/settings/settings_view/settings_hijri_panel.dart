import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/my_colors.dart';
import 'settings_choice_segment.dart';
import 'settings_panel.dart';

class SettingsHijriPanel extends StatelessWidget {
  const SettingsHijriPanel({
    super.key,
    required this.adjustment,
    required this.onAdjustmentChanged,
  });

  final int adjustment;
  final ValueChanged<int> onAdjustmentChanged;

  @override
  Widget build(BuildContext context) {
    final choices = [
      (-1, context.l10n.hijriAdjustmentMinusLabel, Icons.remove_rounded),
      (0, context.l10n.hijriAdjustmentCalculatedLabel, Icons.check_rounded),
      (1, context.l10n.hijriAdjustmentPlusLabel, Icons.add_rounded),
    ];

    return Semantics(
      label: context.l10n.settingsHijriAdjustmentSubtitle,
      child: SettingsPanel(
        title: context.l10n.settingsHijriCalendarTitle,
        icon: Icons.calendar_month_rounded,
        accent: MyColors.secondary,
        child: Row(
          children: [
            for (var index = 0; index < choices.length; index++) ...[
              Expanded(
                child: SettingsChoiceSegment<int>(
                  value: choices[index].$1,
                  selectedValue: adjustment,
                  label: choices[index].$2,
                  icon: choices[index].$3,
                  accent: MyColors.secondary,
                  onSelected: onAdjustmentChanged,
                ),
              ),
              if (index < choices.length - 1)
                const SizedBox(width: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}

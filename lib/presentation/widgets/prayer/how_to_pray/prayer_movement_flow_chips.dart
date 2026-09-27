import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'prayer_movement_flow_chip.dart';
import 'prayer_movement_style.dart';

class PrayerMovementFlowChips extends StatelessWidget {
  const PrayerMovementFlowChips({super.key, required this.steps});

  final List<PrayerMovementStep> steps;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final step in steps)
          PrayerMovementFlowChip(
            number: step.number,
            label: step.title,
            accent: PrayerMovementStyle.accentFor(step.number),
          ),
      ],
    );
  }
}

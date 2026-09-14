import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

import '../shared/prayer_card_shell.dart';

import 'prayer_step_line.dart';

class HowToPraySection extends StatelessWidget {
  const HowToPraySection({super.key, required this.steps});

  final List<PrayerGuidanceItem> steps;

  @override
  Widget build(BuildContext context) {
    return PrayerCardShell(
      child: Column(
        children: [
          for (var index = 0; index < steps.length; index++) ...[
            PrayerStepLine(index: index, step: steps[index]),
            if (index != steps.length - 1)
              const SizedBox(height: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}

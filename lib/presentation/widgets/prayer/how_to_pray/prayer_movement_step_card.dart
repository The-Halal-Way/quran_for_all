import '../shared/prayer_card_shell.dart';
import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'prayer_movement_image_frame.dart';
import 'prayer_movement_step_details.dart';
import 'prayer_movement_style.dart';

class PrayerMovementStepCard extends StatelessWidget {
  const PrayerMovementStepCard({
    super.key,
    required this.step,
    required this.reverseOnWide,
  });

  final PrayerMovementStep step;
  final bool reverseOnWide;

  @override
  Widget build(BuildContext context) {
    final accent = PrayerMovementStyle.accentFor(step.number);

    return PrayerCardShell(
      padding: EdgeInsets.zero,
      borderColor: accent.withValues(alpha: 0.22),
      shadowColor: accent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 760;
          final image = PrayerMovementImageFrame(step: step, accent: accent);
          final details = PrayerMovementStepDetails(step: step, accent: accent);

          if (!isWide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                image,
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: details,
                ),
              ],
            );
          }

          final children = [
            SizedBox(width: 274, child: image),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: details,
              ),
            ),
          ];

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: reverseOnWide ? children.reversed.toList() : children,
          );
        },
      ),
    );
  }
}

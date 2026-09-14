import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';

import '../shared/prayer_card_shell.dart';

import 'prayer_guidance_line.dart';

class PrayerSuggestionsSection extends StatelessWidget {
  const PrayerSuggestionsSection({
    super.key,
    required this.items,
    required this.accent,
  });

  final List<String> items;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return PrayerCardShell(
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            PrayerGuidanceLine(
              icon: Icons.auto_awesome_rounded,
              marker: '${index + 1}',
              body: items[index],
              accent: accent,
            ),
            if (index != items.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

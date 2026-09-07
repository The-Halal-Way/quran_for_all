import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/my_colors.dart';
import 'sunnah_dua_day_ribbon_stop.dart';

class SunnahDuaDayRibbon extends StatelessWidget {
  const SunnahDuaDayRibbon({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.07),
      border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    child: Row(
      children: [
        Expanded(
          child: SunnahDuaDayRibbonStop(
            label: context.l10n.sunnahDuaWakeLabel,
            icon: Icons.wb_twilight_rounded,
            color: MyColors.tertiaryLight,
          ),
        ),
        Container(width: 18, height: 1, color: Colors.white24),
        Expanded(
          child: SunnahDuaDayRibbonStop(
            label: context.l10n.sunnahDuaDayLabel,
            icon: Icons.light_mode_rounded,
            color: MyColors.secondaryLight,
          ),
        ),
        Container(width: 18, height: 1, color: Colors.white24),
        Expanded(
          child: SunnahDuaDayRibbonStop(
            label: context.l10n.sunnahDuaRestLabel,
            icon: Icons.bedtime_rounded,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

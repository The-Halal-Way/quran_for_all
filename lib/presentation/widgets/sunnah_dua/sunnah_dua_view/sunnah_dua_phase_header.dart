import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../models/sunnah_dua_item.dart';

class SunnahDuaPhaseHeader extends StatelessWidget {
  const SunnahDuaPhaseHeader({super.key, required this.phase});
  final SunnahDayPhase phase;

  @override
  Widget build(BuildContext context) {
    final (label, icon, baseAccent) = switch (phase) {
      SunnahDayPhase.morning => (
        context.l10n.sunnahDuaMorningLabel,
        Icons.wb_twilight_rounded,
        MyColors.tertiaryDark,
      ),
      SunnahDayPhase.daytime => (
        context.l10n.sunnahDuaDaytimeLabel,
        Icons.light_mode_rounded,
        MyColors.secondary,
      ),
      SunnahDayPhase.evening => (
        context.l10n.sunnahDuaEveningLabel,
        Icons.nights_stay_rounded,
        Theme.of(context).colorScheme.primary,
      ),
    };
    final accent = Theme.of(context).brightness == Brightness.dark
        ? Color.lerp(baseAccent, Colors.white, 0.5)!
        : baseAccent;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.1),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: AppTheme.text(
                context,
              ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          SizedBox(
            width: 32,
            child: Divider(color: accent.withValues(alpha: 0.4)),
          ),
        ],
      ),
    );
  }
}

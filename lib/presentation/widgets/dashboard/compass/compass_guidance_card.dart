import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/app_theme_colors.dart';

class CompassGuidanceCard extends StatelessWidget {
  const CompassGuidanceCard({
    super.key,
    required this.isLive,
    required this.facingMecca,
    required this.qiblaOffset,
    required this.qiblaDegrees,
  });

  final bool isLive;
  final bool facingMecca;
  final double qiblaOffset;
  final double qiblaDegrees;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final accent = dark ? scheme.tertiary : AppThemeColors.light.cyan;
    final signedTurn = qiblaOffset <= 180 ? qiblaOffset : qiblaOffset - 360;
    final title = !isLive
        ? l10n.compassNorthUpGuidanceTitle
        : facingMecca
        ? l10n.compassFacingMeccaLabel
        : signedTurn >= 0
        ? l10n.compassTurnRight(signedTurn.abs().toStringAsFixed(0))
        : l10n.compassTurnLeft(signedTurn.abs().toStringAsFixed(0));
    final detail = isLive
        ? l10n.compassLiveInstruction
        : l10n.compassFallbackInstruction(qiblaDegrees.toStringAsFixed(0));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: dark
            ? scheme.surfaceContainerHigh
            : AppThemeColors.light.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.13),
            ),
            child: Icon(
              isLive ? Icons.navigation_rounded : Icons.map_rounded,
              color: accent,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: text.titleSmall.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  detail,
                  style: text.bodySmall.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

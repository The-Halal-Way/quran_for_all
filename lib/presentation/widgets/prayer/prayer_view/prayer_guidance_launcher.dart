import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../data/models/prayer/prayer_detail_models.dart';
import '../prayer_guidance/prayer_guidance_sheet.dart';

class PrayerGuidanceLauncher extends StatelessWidget {
  const PrayerGuidanceLauncher({super.key, required this.content});

  final PrayerFocusContent content;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? MyColors.tertiaryLight : MyColors.tertiaryDark;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              accent.withValues(alpha: 0.1),
              accent.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: accent.withValues(alpha: 0.22)),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: InkWell(
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            barrierColor: MyColors.primaryDark.withValues(alpha: 0.58),
            builder: (_) =>
                PrayerGuidanceSheet(content: content, accent: accent),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.route_rounded, color: accent, size: 25),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(content.now.title, style: text.titleMedium),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(Icons.arrow_forward_rounded, color: accent, size: 20),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  context.l10n.prayerViewNowSubtitle,
                  style: text.bodyMedium.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  context.l10n.prayerRakatViewDetails,
                  style: text.labelMedium.copyWith(
                    color: accent,
                    fontWeight: AppTheme.weightBold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

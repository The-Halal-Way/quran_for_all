import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../data/models/prayer/prayer_detail_models.dart';
import '../prayer_visuals.dart';
import 'prayer_guidance_sheet.dart';

class PrayerGuidanceLauncher extends StatelessWidget {
  const PrayerGuidanceLauncher({super.key, required this.content});

  final PrayerFocusContent content;

  @override
  Widget build(BuildContext context) {
    final accent = PrayerVisuals.accentFor(content.prayer);
    final text = AppTheme.text(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? MyColors.darkCardFill : Colors.white;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openSheet(context, accent),
        child: Ink(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [surface, Color.lerp(surface, accent, 0.1)!],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            border: Border.all(color: accent.withValues(alpha: 0.22)),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(Icons.route_rounded, color: accent, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.now.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleMedium.copyWith(
                        fontWeight: AppTheme.weightExtraBold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.prayerViewNowSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(Icons.arrow_forward_rounded, color: accent, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openSheet(BuildContext context, Color accent) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: MyColors.primaryDark.withValues(alpha: 0.58),
      builder: (_) => PrayerGuidanceSheet(content: content, accent: accent),
    );
  }
}

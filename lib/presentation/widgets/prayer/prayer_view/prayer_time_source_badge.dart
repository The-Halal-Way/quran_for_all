import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

class PrayerTimeSourceBadge extends StatelessWidget {
  const PrayerTimeSourceBadge({super.key, required this.hasTimes});

  final bool hasTimes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasTimes ? Icons.location_on_outlined : Icons.menu_book_rounded,
            color: MyColors.tertiaryLight,
            size: 15,
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              hasTimes
                  ? context.l10n.prayerViewLoadedFromLocation
                  : context.l10n.prayerViewTimeFallback,
              style: AppTheme.text(context).labelSmall.copyWith(
                color: Colors.white.withValues(alpha: 0.88),
                fontWeight: AppTheme.weightBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

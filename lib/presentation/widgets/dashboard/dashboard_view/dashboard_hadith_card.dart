import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class DashboardHadithCard extends StatelessWidget {
  const DashboardHadithCard({
    super.key,
    required this.arabicTitle,
    required this.title,
    required this.description,
    required this.gradient,
    required this.onTap,
  });
  final String arabicTitle, title, description;
  final List<Color> gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    return Semantics(
      button: true,
      onTap: onTap,
      excludeSemantics: true,
      label: '$title. $description',
      child: Material(
        color: colors.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: gradient.last.withValues(alpha: 0.22)),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 58,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        NumberFormat.decimalPattern(
                          context.l10n.localeName,
                        ).format(40),
                        style: text.dashboardHadithNumber.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.dailyTrackerCategoryHadith,
                        textAlign: TextAlign.center,
                        style: text.dashboardHadithLabel.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        arabicTitle,
                        textDirection: TextDirection.rtl,
                        style: text.dashboardHadithArabicTitle.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(title, style: text.dashboardHadithTitle),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        description,
                        style: text.dashboardHadithDescription.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colors.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_for_all/core/theme/app_shadows.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

class PrayerVisuals {
  const PrayerVisuals._();

  static IconData iconFor(PrayerKey prayer) {
    switch (prayer) {
      case PrayerKey.fajr:
        return Icons.wb_twilight_rounded;
      case PrayerKey.sunrise:
        return Icons.wb_sunny_rounded;
      case PrayerKey.dhuhr:
        return Icons.light_mode_rounded;
      case PrayerKey.asr:
        return Icons.cloud_rounded;
      case PrayerKey.maghrib:
        return Icons.nights_stay_rounded;
      case PrayerKey.isha:
        return Icons.bedtime_rounded;
    }
  }

  static Color accentFor(PrayerKey prayer) {
    switch (prayer) {
      case PrayerKey.fajr:
        return const Color(0xFF64FFDA);
      case PrayerKey.sunrise:
        return const Color(0xFFFFC857);
      case PrayerKey.dhuhr:
        return const Color(0xFF448AFF);
      case PrayerKey.asr:
        return const Color(0xFF00BFA5);
      case PrayerKey.maghrib:
        return const Color(0xFFFF4081);
      case PrayerKey.isha:
        return const Color(0xFFB388FF);
    }
  }
}

class PrayerCardShell extends StatelessWidget {
  const PrayerCardShell({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.margin,
    this.gradient,
    this.color,
    this.borderColor,
    this.shadowColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Gradient? gradient;
  final Color? color;
  final Color? borderColor;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = color ?? (isDark ? MyColors.darkCardFill : Colors.white);
    final border =
        borderColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.07)
            : MyColors.divider.withValues(alpha: 0.85));

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? surface : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: border, width: 0.8),
        boxShadow: AppShadows.card(tint: shadowColor ?? MyColors.primary),
      ),
      child: child,
    );
  }
}

class PrayerSectionHeader extends StatelessWidget {
  const PrayerSectionHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.accent,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final subColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: isDark ? 0.18 : 0.12),
              borderRadius: BorderRadius.circular(AppRadius.xs),
              border: Border.all(color: accent.withValues(alpha: 0.28)),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.sora(
                    color: textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: GoogleFonts.manrope(
                      color: subColor,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

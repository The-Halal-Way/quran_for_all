import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../shared/islamic_day_badge.dart';
import '../shared/islamic_days_artwork.dart';

class IslamicDaysHero extends StatelessWidget {
  const IslamicDaysHero({
    super.key,
    required this.hijriDate,
    required this.gregorianDate,
  });
  final String hijriDate;
  final String gregorianDate;

  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppThemeColors.light.heroStart,
          AppThemeColors.light.heroMiddle,
          AppThemeColors.light.heroEnd,
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: .18),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Stack(
      children: [
        const Positioned(
          right: -32,
          top: -34,
          width: 235,
          height: 235,
          child: IslamicDaysArtwork(color: Color(0xFFEED59D)),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IslamicDayBadge(
                label: context.l10n.islamicDaysToday,
                icon: Icons.auto_awesome,
                color: const Color(0xFFEED59D),
                onDark: true,
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n.islamicDaysTitle,
                style: AppTheme.text(context).headlineMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.islamicDaysSubtitle,
                style: AppTheme.text(context).bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: .82),
                ),
              ),
              const SizedBox(height: 22),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  IslamicDayBadge(
                    label: hijriDate,
                    icon: Icons.nightlight_round,
                    color: Colors.white,
                    onDark: true,
                  ),
                  IslamicDayBadge(
                    label: gregorianDate,
                    icon: Icons.calendar_today_outlined,
                    color: Colors.white,
                    onDark: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

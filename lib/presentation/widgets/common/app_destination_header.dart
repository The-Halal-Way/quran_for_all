import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/my_colors.dart';
import 'app_destination_artwork.dart';

/// Premium, dashboard-aware header for secondary app destinations.
class AppDestinationHeader extends StatelessWidget {
  const AppDestinationHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.icon,
    required this.accent,
    required this.onBack,
    this.subtitle,
    this.artworkLabel,
    this.trailing,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final String? artworkLabel;
  final IconData icon;
  final Color accent;
  final VoidCallback onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final surface = isDark ? MyColors.darkCardFill : Colors.white;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.lerp(surface, accent, isDark ? 0.22 : 0.13)!, surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: accent.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: isDark ? 0.10 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton.filledTonal(
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                style: IconButton.styleFrom(
                  foregroundColor: accent,
                  backgroundColor: accent.withValues(alpha: 0.11),
                ),
              ),
              const Spacer(),
              ?trailing,
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eyebrow.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelSmall.copyWith(
                        color: accent,
                        fontWeight: AppTheme.weightExtraBold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.headlineMedium.copyWith(
                        color: textColor,
                        fontWeight: AppTheme.weightBlack,
                        height: 1.08,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall.copyWith(
                          color: textColor.withValues(alpha: 0.62),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              AppDestinationArtwork(
                icon: icon,
                label: artworkLabel,
                accent: accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

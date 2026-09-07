import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import 'settings_hero_artwork.dart';

class SettingsHero extends StatelessWidget {
  const SettingsHero({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 680;

        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  MyColors.primaryDark,
                  MyColors.primary,
                  MyColors.primaryLight,
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? AppSpacing.lg : AppSpacing.xxxl,
                vertical: compact ? AppSpacing.lg : AppSpacing.xxl,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (onBack != null) ...[
                          _BackButton(onPressed: onBack!),
                          const SizedBox(height: AppSpacing.sm),
                        ],
                        Text(
                          context.l10n.settingsTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.headlineMedium.copyWith(
                            color: Colors.white,
                            fontWeight: AppTheme.weightBlack,
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          context.l10n.settingsIntro,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.72),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: compact ? AppSpacing.sm : AppSpacing.xl),
                  SettingsHeroArtwork(size: compact ? 108 : 142),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.12),
        foregroundColor: Colors.white,
        fixedSize: const Size(34, 34),
        minimumSize: const Size(34, 34),
        padding: EdgeInsets.zero,
      ),
      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 17),
    );
  }
}

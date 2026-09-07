import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import 'sunnah_dua_hero_artwork.dart';

class SunnahDuaHero extends StatelessWidget {
  const SunnahDuaHero({super.key, this.onBack});

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
                  Color(0xFF5A1458),
                ],
                stops: [0, 0.58, 1],
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
                          context.l10n.sunnahDuaHeroEyebrow.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.labelSmall.copyWith(
                            color: MyColors.tertiaryLight,
                            fontWeight: AppTheme.weightBold,
                            letterSpacing: 1.05,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          context.l10n.sunnahDuaTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: text.headlineMedium.copyWith(
                            color: Colors.white,
                            fontWeight: AppTheme.weightBlack,
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          width: 42,
                          height: 1,
                          color: MyColors.tertiaryLight.withValues(alpha: 0.8),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: compact ? AppSpacing.sm : AppSpacing.xl),
                  SunnahDuaHeroArtwork(
                    arabicTitle: context.l10n.sunnahDuaHeroArabic,
                    size: compact ? 116 : 150,
                  ),
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

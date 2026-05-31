import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

// MARK: Prayer - Reference Navigation Grid
class PrayerReferenceActions extends StatelessWidget {
  const PrayerReferenceActions({
    super.key,
    required this.onMovementGuideTap,
    required this.onForbiddenTimesTap,
    required this.onNafalPrayersTap,
    required this.onJanazaPrayerTap,
    required this.onSalatulTasbeehTap,
  });

  final VoidCallback onMovementGuideTap;
  final VoidCallback onForbiddenTimesTap;
  final VoidCallback onNafalPrayersTap;
  final VoidCallback onJanazaPrayerTap;
  final VoidCallback onSalatulTasbeehTap;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _PrayerReferenceAction(
        title: context.l10n.prayerReferenceMovementsActionTitle,
        subtitle: context.l10n.prayerReferenceMovementsActionSubtitle,
        icon: Icons.self_improvement_rounded,
        startColor: MyColors.primaryLight,
        endColor: MyColors.secondary,
        onTap: onMovementGuideTap,
      ),
      _PrayerReferenceAction(
        title: context.l10n.prayerReferenceForbiddenActionTitle,
        subtitle: context.l10n.prayerReferenceForbiddenActionSubtitle,
        icon: Icons.block_rounded,
        startColor: MyColors.secondary,
        endColor: MyColors.primaryLight,
        onTap: onForbiddenTimesTap,
      ),
      _PrayerReferenceAction(
        title: context.l10n.prayerReferenceNafalActionTitle,
        subtitle: context.l10n.prayerReferenceNafalActionSubtitle,
        icon: Icons.auto_awesome_rounded,
        startColor: MyColors.tertiaryDark,
        endColor: MyColors.secondaryLight,
        onTap: onNafalPrayersTap,
      ),
      _PrayerReferenceAction(
        title: context.l10n.prayerReferenceJanazaActionTitle,
        subtitle: context.l10n.prayerReferenceJanazaActionSubtitle,
        icon: Icons.volunteer_activism_rounded,
        startColor: MyColors.info,
        endColor: MyColors.tertiary,
        onTap: onJanazaPrayerTap,
      ),
      _PrayerReferenceAction(
        title: context.l10n.prayerReferenceTasbeehActionTitle,
        subtitle: context.l10n.prayerReferenceTasbeehActionSubtitle,
        icon: Icons.brightness_5_rounded,
        startColor: MyColors.secondaryLight,
        endColor: MyColors.primaryLight,
        onTap: onSalatulTasbeehTap,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 940
            ? 5
            : constraints.maxWidth >= 620
            ? 3
            : 2;
        const gap = AppSpacing.sm;
        final itemWidth =
            (constraints.maxWidth - (columns - 1) * gap) / columns;
        final itemHeight = columns == 2
            ? 108.0
            : columns == 3
            ? 118.0
            : 112.0;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final action in actions)
              SizedBox(
                width: itemWidth,
                height: itemHeight,
                child: _PrayerReferenceActionButton(
                  action: action,
                  showSubtitle: columns > 2,
                ),
              ),
          ],
        );
      },
    );
  }
}

// MARK: Prayer - Reference Action Data
class _PrayerReferenceAction {
  const _PrayerReferenceAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.startColor,
    required this.endColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color startColor;
  final Color endColor;
  final VoidCallback onTap;
}

// MARK: Prayer - Reference Action Button
class _PrayerReferenceActionButton extends StatelessWidget {
  const _PrayerReferenceActionButton({
    required this.action,
    required this.showSubtitle,
  });

  final _PrayerReferenceAction action;
  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final hintColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;
    final fill = isDark ? MyColors.darkCardFill : Colors.white;

    return Semantics(
      button: true,
      label: action.title,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: action.onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Ink(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: action.startColor.withValues(
                  alpha: isDark ? 0.28 : 0.16,
                ),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: action.startColor.withValues(
                    alpha: isDark ? 0.14 : 0.08,
                  ),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            action.startColor.withValues(
                              alpha: isDark ? 0.28 : 0.16,
                            ),
                            action.endColor.withValues(
                              alpha: isDark ? 0.22 : 0.11,
                            ),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Icon(
                        action.icon,
                        color: action.startColor,
                        size: 18,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: hintColor.withValues(alpha: 0.78),
                      size: 18,
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  action.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.prayerTimelineNameActive.copyWith(
                    color: titleColor,
                    height: 1.16,
                  ),
                ),
                if (showSubtitle) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    action.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall.copyWith(
                      color: hintColor,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

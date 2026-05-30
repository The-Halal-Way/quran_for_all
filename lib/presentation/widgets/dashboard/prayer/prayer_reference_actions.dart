import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

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
        final columns = constraints.maxWidth >= 820
            ? 3
            : constraints.maxWidth >= 520
            ? 2
            : 1;
        final itemHeight = columns == 1 ? 150.0 : 170.0;

        return GridView.builder(
          itemCount: actions.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            mainAxisExtent: itemHeight,
          ),
          itemBuilder: (context, index) {
            return _PrayerReferenceActionButton(action: actions[index]);
          },
        );
      },
    );
  }
}

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

class _PrayerReferenceActionButton extends StatelessWidget {
  const _PrayerReferenceActionButton({required this.action});

  final _PrayerReferenceAction action;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Semantics(
      button: true,
      label: action.title,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: action.onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Ink(
            padding: const EdgeInsets.all(AppSpacing.sm + 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              gradient: LinearGradient(
                colors: [action.startColor, action.endColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: action.startColor.withValues(alpha: 0.24),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
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
                      width: 38,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.17),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.22),
                        ),
                      ),
                      child: Icon(action.icon, color: Colors.white, size: 18),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.l10n.prayerReferenceOpenLabel,
                            style: text.prayerStatusChip.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm + 2),
                Text(
                  action.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.prayerTimelineNameActive.copyWith(
                    color: Colors.white,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  action.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.86),
                    height: 1.45,
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

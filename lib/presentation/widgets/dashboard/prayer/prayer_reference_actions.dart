import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

class PrayerReferenceActions extends StatelessWidget {
  const PrayerReferenceActions({
    super.key,
    required this.onForbiddenTimesTap,
    required this.onNafalPrayersTap,
  });

  final VoidCallback onForbiddenTimesTap;
  final VoidCallback onNafalPrayersTap;

  @override
  Widget build(BuildContext context) {
    final actions = [
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
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 680) {
          return Row(
            children: [
              Expanded(child: _PrayerReferenceActionButton(action: actions[0])),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _PrayerReferenceActionButton(action: actions[1])),
            ],
          );
        }

        return Column(
          children: [
            _PrayerReferenceActionButton(action: actions[0]),
            const SizedBox(height: AppSpacing.md),
            _PrayerReferenceActionButton(action: actions[1]),
          ],
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
            padding: const EdgeInsets.all(AppSpacing.md),
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
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.17),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.22),
                        ),
                      ),
                      child: Icon(action.icon, color: Colors.white, size: 20),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
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
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  action.title,
                  style: text.prayerTimelineNameActive.copyWith(
                    color: Colors.white,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  action.subtitle,
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

import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import 'wudu_hero.dart';
import 'wudu_reference_card.dart';
import 'wudu_step_card.dart';
import 'wudu_step_type.dart';

class WuduContent extends StatelessWidget {
  const WuduContent({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final l10n = context.l10n;
    final steps = [
      (
        type: WuduStepType.hands,
        title: l10n.prayerWuduStep1Title,
        body: l10n.prayerWuduStep1Body,
        accent: MyColors.secondary,
      ),
      (
        type: WuduStepType.mouth,
        title: l10n.prayerWuduStep2Title,
        body: l10n.prayerWuduStep2Body,
        accent: MyColors.tertiary,
      ),
      (
        type: WuduStepType.nose,
        title: l10n.prayerWuduStep3Title,
        body: l10n.prayerWuduStep3Body,
        accent: MyColors.primaryLight,
      ),
      (
        type: WuduStepType.face,
        title: l10n.prayerWuduStep4Title,
        body: l10n.prayerWuduStep4Body,
        accent: MyColors.secondary,
      ),
      (
        type: WuduStepType.arms,
        title: l10n.prayerWuduStep5Title,
        body: l10n.prayerWuduStep5Body,
        accent: MyColors.tertiary,
      ),
      (
        type: WuduStepType.head,
        title: l10n.prayerWuduStep6Title,
        body: l10n.prayerWuduStep6Body,
        accent: MyColors.primaryLight,
      ),
      (
        type: WuduStepType.ears,
        title: l10n.prayerWuduStep7Title,
        body: l10n.prayerWuduStep7Body,
        accent: MyColors.secondary,
      ),
      (
        type: WuduStepType.feet,
        title: l10n.prayerWuduStep8Title,
        body: l10n.prayerWuduStep8Body,
        accent: MyColors.tertiary,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WuduHero(),
        const SizedBox(height: AppSpacing.xl),
        Text(
          l10n.prayerWuduStepsTitle,
          style: text.titleLarge.copyWith(fontWeight: AppTheme.weightExtraBold),
        ),
        const SizedBox(height: AppSpacing.md),
        for (var index = 0; index < steps.length; index++) ...[
          WuduStepCard(
            number: index + 1,
            type: steps[index].type,
            title: steps[index].title,
            body: steps[index].body,
            accent: steps[index].accent,
          ),
          if (index != steps.length - 1) const SizedBox(height: AppSpacing.md),
        ],
        const SizedBox(height: AppSpacing.xl),
        _WuduNoteCard(
          title: l10n.prayerWuduNoteTitle,
          body: l10n.prayerWuduNoteBody,
        ),
        const SizedBox(height: AppSpacing.xl),
        const WuduReferenceCard(),
      ],
    );
  }
}

class _WuduNoteCard extends StatelessWidget {
  const _WuduNoteCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface,
        gradient: LinearGradient(
          colors: [MyColors.secondary.withValues(alpha: 0.1), scheme.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: MyColors.secondary.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: text.titleMedium.copyWith(
              fontWeight: AppTheme.weightExtraBold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(body, style: text.bodyMedium.copyWith(height: 1.55)),
        ],
      ),
    );
  }
}

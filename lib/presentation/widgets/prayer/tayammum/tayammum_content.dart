import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import 'tayammum_hero.dart';
import 'tayammum_info_card.dart';
import 'tayammum_reference_card.dart';
import 'tayammum_step_card.dart';
import 'tayammum_step_type.dart';

class TayammumContent extends StatelessWidget {
  const TayammumContent({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TayammumHero(),
        const SizedBox(height: AppSpacing.xl),
        TayammumInfoCard(
          icon: Icons.info_outline_rounded,
          title: context.l10n.prayerTayammumWhenTitle,
          body: context.l10n.prayerTayammumWhenBody,
          accent: MyColors.tertiary,
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          context.l10n.prayerTayammumStepsTitle,
          style: text.titleLarge.copyWith(fontWeight: AppTheme.weightExtraBold),
        ),
        const SizedBox(height: AppSpacing.md),
        TayammumStepCard(
          number: 1,
          type: TayammumStepType.earth,
          title: context.l10n.prayerTayammumStep1Title,
          body: context.l10n.prayerTayammumStep1Body,
          accent: MyColors.secondary,
        ),
        const SizedBox(height: AppSpacing.md),
        TayammumStepCard(
          number: 2,
          type: TayammumStepType.face,
          title: context.l10n.prayerTayammumStep2Title,
          body: context.l10n.prayerTayammumStep2Body,
          accent: MyColors.tertiary,
        ),
        const SizedBox(height: AppSpacing.md),
        TayammumStepCard(
          number: 3,
          type: TayammumStepType.hands,
          title: context.l10n.prayerTayammumStep3Title,
          body: context.l10n.prayerTayammumStep3Body,
          accent: MyColors.primaryLight,
        ),
        const SizedBox(height: AppSpacing.xl),
        TayammumInfoCard(
          icon: Icons.lightbulb_outline_rounded,
          title: context.l10n.prayerTayammumNoteTitle,
          body: context.l10n.prayerTayammumNoteBody,
          accent: MyColors.secondary,
        ),
        const SizedBox(height: AppSpacing.xl),
        const TayammumReferenceCard(),
      ],
    );
  }
}

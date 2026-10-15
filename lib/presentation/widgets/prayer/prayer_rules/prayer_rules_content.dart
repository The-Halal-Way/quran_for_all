import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import 'prayer_rules_hero.dart';
import 'prayer_rules_note_card.dart';
import 'prayer_rules_reference_card.dart';
import 'prayer_rules_section_card.dart';

class PrayerRulesContent extends StatelessWidget {
  const PrayerRulesContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = AppTheme.text(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PrayerRulesHero(),
        const SizedBox(height: AppSpacing.xl),
        PrayerRulesSectionCard(
          title: l10n.prayerRulesBeforePrayerTitle,
          accent: MyColors.tertiary,
          items: [
            l10n.prayerRulesBeforePrayerItem1,
            l10n.prayerRulesBeforePrayerItem2,
            l10n.prayerRulesBeforePrayerItem3,
            l10n.prayerRulesBeforePrayerItem4,
            l10n.prayerRulesBeforePrayerItem5,
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        PrayerRulesSectionCard(
          title: l10n.prayerRulesWuduBreaksTitle,
          accent: MyColors.secondary,
          items: [
            l10n.prayerRulesWuduBreaksItem1,
            l10n.prayerRulesWuduBreaksItem2,
            l10n.prayerRulesWuduBreaksItem3,
            l10n.prayerRulesWuduBreaksItem4,
            l10n.prayerRulesWuduBreaksItem5,
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        PrayerRulesSectionCard(
          title: l10n.prayerRulesPrayerBreaksTitle,
          accent: MyColors.primaryLight,
          items: [
            l10n.prayerRulesPrayerBreaksItem1,
            l10n.prayerRulesPrayerBreaksItem2,
            l10n.prayerRulesPrayerBreaksItem3,
            l10n.prayerRulesPrayerBreaksItem4,
            l10n.prayerRulesPrayerBreaksItem5,
            l10n.prayerRulesPrayerBreaksItem6,
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        PrayerRulesNoteCard(
          title: l10n.prayerRulesNoteTitle,
          body: l10n.prayerRulesNoteBody,
        ),
        const SizedBox(height: AppSpacing.xl),
        const PrayerRulesReferenceCard(),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.prayerRulesSubtitle,
          style: text.bodySmall.copyWith(height: 1.45),
        ),
      ],
    );
  }
}

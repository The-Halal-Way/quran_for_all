import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../views/prayer/prayer_rules/prayer_rules_view.dart';
import 'prayer_section_heading.dart';

/// Entry points to the three existing rule checklists.
class PrayerValiditySection extends StatelessWidget {
  const PrayerValiditySection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    void open(PrayerRuleTopic topic) => Navigator.of(context).push(
      AppPageRoute<void>(builder: (_) => PrayerRulesView(initialTopic: topic)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrayerSectionHeading(
          title: l10n.prayerValiditySectionTitle,
          icon: Icons.verified_user_outlined,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.prayerValiditySectionSubtitle,
          style: AppTheme.text(context).bodySmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _RuleTopicCard(
          number: '01',
          title: l10n.prayerRulesBeforePrayerTitle,
          description: l10n.prayerValidityBeforeSummary,
          icon: Icons.fact_check_outlined,
          accent: MyColors.tertiary,
          onTap: () => open(PrayerRuleTopic.beforePrayer),
        ),
        const SizedBox(height: AppSpacing.sm),
        _RuleTopicCard(
          number: '02',
          title: l10n.prayerRulesWuduBreaksTitle,
          description: l10n.prayerValidityWuduSummary,
          icon: Icons.water_drop_outlined,
          accent: MyColors.secondary,
          onTap: () => open(PrayerRuleTopic.wuduBreaks),
        ),
        const SizedBox(height: AppSpacing.sm),
        _RuleTopicCard(
          number: '03',
          title: l10n.prayerRulesPrayerBreaksTitle,
          description: l10n.prayerValidityPrayerSummary,
          icon: Icons.self_improvement_rounded,
          accent: MyColors.primaryLight,
          onTap: () => open(PrayerRuleTopic.prayerBreaks),
        ),
      ],
    );
  }
}

class _RuleTopicCard extends StatelessWidget {
  const _RuleTopicCard({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String number, title, description;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = Theme.of(context).brightness == Brightness.dark
        ? Color.lerp(accent, Colors.white, .35)!
        : accent;
    final radius = BorderRadius.circular(AppRadius.lg);
    final text = AppTheme.text(context);
    return Material(
      color: Color.alphaBlend(color.withValues(alpha: .055), scheme.surface),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: color.withValues(alpha: .28)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, color: color, size: 27),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: text.titleMedium.copyWith(
                        fontWeight: AppTheme.weightBold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      description,
                      style: text.bodySmall.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    number,
                    style: text.labelSmall.copyWith(
                      color: color,
                      fontWeight: AppTheme.weightBold,
                    ),
                  ),
                  Icon(Icons.arrow_outward_rounded, color: color, size: 19),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

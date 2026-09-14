import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../data/models/prayer/prayer_detail_models.dart';
import '../../common/app_premium_section_title.dart';
import 'prayer_now_card.dart';
import 'prayer_suggestions_section.dart';
import 'prayer_best_practices_section.dart';
import 'prayer_fiqh_note.dart';

class PrayerGuidanceSheet extends StatelessWidget {
  const PrayerGuidanceSheet({
    super.key,
    required this.content,
    required this.accent,
  });

  final PrayerFocusContent content;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? MyColors.darkSurface : Colors.white;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.82,
      minChildSize: 0.48,
      maxChildSize: 0.94,
      builder: (context, controller) => DecoratedBox(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xxxl,
          ),
          children: [
            AppPremiumSectionTitle(title: context.l10n.prayerViewNowTitle),
            const SizedBox(height: AppSpacing.md),
            PrayerNowCard(content: content),
            const SizedBox(height: AppSpacing.xxl),
            AppPremiumSectionTitle(
              title: context.l10n.prayerViewSuggestionsTitle,
            ),
            const SizedBox(height: AppSpacing.md),
            PrayerSuggestionsSection(
              items: content.suggestions,
              accent: MyColors.secondary,
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppPremiumSectionTitle(
              title: context.l10n.prayerViewBestPracticesTitle,
            ),
            const SizedBox(height: AppSpacing.md),
            BestPracticesSection(items: content.bestPractices, accent: accent),
            const PrayerFiqhNote(),
          ],
        ),
      ),
    );
  }
}

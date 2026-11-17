import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/sunnah/sunnah_catalog.dart';
import '../../../../l10n/app_localizations.dart';
import '../catalog/dua_source_link.dart';

class SunnahHadithCard extends StatelessWidget {
  const SunnahHadithCard({super.key, required this.hadith});
  final SunnahHadith hadith;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final language = l10n.localeName;
    final scheme = Theme.of(context).colorScheme;
    final grade = hadith.grading.inLanguage(language);
    final gradedBy = hadith.gradedBy.inLanguage(language);
    final relationship = sunnahReportRelation(l10n, hadith.relation);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${hadith.collection.inLanguage(language)} ${hadith.number}',
            style: AppTheme.text(
              context,
            ).labelLarge.copyWith(fontWeight: AppTheme.weightBold),
          ),
          if (relationship.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              relationship,
              style: AppTheme.text(
                context,
              ).labelSmall.copyWith(color: scheme.secondary),
            ),
          ],
          if (grade.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              gradedBy.isEmpty ? grade : l10n.sunnahGradeBy(grade, gradedBy),
              style: AppTheme.text(context).labelSmall.copyWith(
                color: scheme.primary,
                fontWeight: AppTheme.weightBold,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Text(hadith.summary.inLanguage(language)),
          for (final source in hadith.sourceCollections) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.sunnahOriginalCollection(
                '${source.collection.inLanguage(language)} ${source.number}',
              ),
              style: AppTheme.text(context).bodySmall,
            ),
            if (source.url.isNotEmpty)
              DuaSourceLink(label: l10n.sunnahOpenSource, url: source.url),
          ],
          if (hadith.url.isNotEmpty)
            DuaSourceLink(label: l10n.sunnahOpenSource, url: hadith.url),
        ],
      ),
    );
  }
}

String sunnahReportRelation(AppLocalizations l10n, String relation) =>
    switch (relation) {
      'other_reported_practice' => l10n.sunnahRelationAlternative,
      'calendar_exception' => l10n.sunnahRelationCalendarException,
      'supports_wording' => l10n.sunnahRelationWording,
      'supporting' => l10n.sunnahRelationSupporting,
      'congregation_context' => l10n.sunnahRelationCongregation,
      'pilgrim_context' => l10n.sunnahRelationPilgrim,
      _ => '',
    };

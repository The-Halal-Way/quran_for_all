import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/dua/dua_catalog.dart';
import 'dua_source_link.dart';

class DuaHadithCard extends StatelessWidget {
  const DuaHadithCard({super.key, required this.hadith});
  final DuaHadith hadith;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final language = l10n.localeName;
    final text = AppTheme.text(context);
    final reportType = l10n.duaReportType(hadith.reportType);
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${hadith.collection.inLanguage(language)} ${hadith.number}',
            style: text.labelLarge.copyWith(fontWeight: AppTheme.weightBold),
          ),
          if (reportType.isNotEmpty) Text(reportType, style: text.labelSmall),
          DuaHadithGradingText(grading: hadith.grading),
          if (hadith.grading.opinions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.duaGradingOpinions, style: text.labelLarge),
            for (final opinion in hadith.grading.opinions)
              DuaHadithGradingText(grading: opinion),
          ],
          if (!hadith.summary.isEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              hadith.summary.inLanguage(language),
              style: text.bodyMedium.copyWith(height: 1.6),
            ),
          ],
          if (hadith.url.isNotEmpty)
            DuaSourceLink(label: l10n.duaOpenReference, url: hadith.url),
          if (hadith.wordingUrl.isNotEmpty && hadith.wordingUrl != hadith.url)
            DuaSourceLink(
              label: l10n.duaWordingReference,
              url: hadith.wordingUrl,
            ),
        ],
      ),
    );
  }
}

class DuaHadithGradingText extends StatelessWidget {
  const DuaHadithGradingText({super.key, required this.grading});
  final DuaHadithGrading grading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final language = l10n.localeName;
    final text = AppTheme.text(context);
    final grade = grading.label.inLanguage(language);
    final by = grading.by.inLanguage(language);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (grade.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            by.isEmpty ? grade : l10n.sunnahGradeBy(grade, by),
            style: text.labelMedium.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
        if (!grading.attribution.isEmpty)
          Text(grading.attribution.inLanguage(language), style: text.bodySmall),
        if (grading.url.isNotEmpty)
          DuaSourceLink(label: l10n.duaGradingReference, url: grading.url),
      ],
    );
  }
}

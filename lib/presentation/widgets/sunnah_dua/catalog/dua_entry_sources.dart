import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/dua/dua_catalog.dart';
import 'dua_detail_section.dart';
import 'dua_reading_panel.dart';
import 'dua_source_link.dart';

class DuaEntrySources extends StatelessWidget {
  const DuaEntrySources({
    super.key,
    required this.entry,
    required this.description,
  });
  final DuaEntry entry;
  final DuaText description;

  @override
  Widget build(BuildContext context) {
    final language = context.l10n.localeName;
    final text = AppTheme.text(context);
    return DuaDetailSection(
      title: context.l10n.sunnahDuaSourceLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!description.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(
                description.inLanguage(language),
                style: text.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          if (!entry.sourceNote.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: SelectableText(
                entry.sourceNote.inLanguage(language),
                style: text.bodyMedium,
              ),
            ),
          if (!entry.sourceText.isEmpty)
            SelectableText(
              entry.sourceText.inLanguage(language),
              style: text.bodyMedium,
            ),
          for (final reference in entry.quranReferences)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: DuaSourceLink(
                label: duaQuranLabel(context, reference),
                url: duaString(reference['url']),
              ),
            ),
          for (final report in entry.hadith)
            Container(
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
                    '${report.collection.inLanguage(language)} ${report.number}',
                    style: text.labelLarge.copyWith(
                      fontWeight: AppTheme.weightBold,
                    ),
                  ),
                  if (!report.grade.isEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      report.grade.inLanguage(language),
                      style: text.labelMedium.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  SelectableText(
                    report.summary.inLanguage(language),
                    style: text.bodyMedium.copyWith(height: 1.6),
                  ),
                  if (report.url.isNotEmpty)
                    DuaSourceLink(
                      label: context.l10n.duaOpenReference,
                      url: report.url,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

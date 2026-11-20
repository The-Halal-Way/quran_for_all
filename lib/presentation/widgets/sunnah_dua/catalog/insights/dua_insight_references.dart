import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/dua/dua_catalog.dart';
import '../dua_source_link.dart';

class DuaInsightReferences extends StatelessWidget {
  const DuaInsightReferences({super.key, required this.references});
  final List<DuaInsightReference> references;

  @override
  Widget build(BuildContext context) {
    final language = context.l10n.localeName;
    final style = AppTheme.text(context).labelSmall.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      height: 1.5,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final reference in references) ...[
          DuaSourceLink(
            label: reference.label.inLanguage(language),
            url: reference.url,
          ),
          if (!reference.grading.label.isEmpty)
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.sm,
                bottom: AppSpacing.sm,
              ),
              child: Text(
                [
                  reference.grading.label.inLanguage(language),
                  if (!reference.grading.by.isEmpty)
                    reference.grading.by.inLanguage(language),
                  if (!reference.grading.attribution.isEmpty)
                    reference.grading.attribution.inLanguage(language),
                ].join(' · '),
                style: style,
              ),
            ),
          if (reference.grading.url.isNotEmpty &&
              reference.grading.url != reference.url)
            DuaSourceLink(
              label: reference.grading.label.inLanguage(language),
              url: reference.grading.url,
            ),
          for (final opinion in reference.grading.opinions)
            if (opinion.url.isNotEmpty)
              DuaSourceLink(
                label: [
                  opinion.label.inLanguage(language),
                  opinion.by.inLanguage(language),
                ].where((s) => s.isNotEmpty).join(' · '),
                url: opinion.url,
              )
            else
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Text(
                  [
                    opinion.label.inLanguage(language),
                    opinion.by.inLanguage(language),
                  ].where((s) => s.isNotEmpty).join(' · '),
                  style: style,
                ),
              ),
        ],
      ],
    );
  }
}

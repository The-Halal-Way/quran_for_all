import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/dua/dua_catalog.dart';
import 'dua_detail_section.dart';
import 'dua_reading_panel.dart';

class DuaEntryContext extends StatelessWidget {
  const DuaEntryContext({super.key, required this.entry});
  final DuaEntry entry;

  @override
  Widget build(BuildContext context) {
    final language = context.l10n.localeName;
    final text = AppTheme.text(context);
    final practice = DuaText(entry.context['practice']).inLanguage(language);
    final points = duaLocalizedLines(entry.context['points'], language);
    final referenceParts = entry.segments
        .where((part) => part.referenceOnly)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (practice.isNotEmpty || points.isNotEmpty)
          DuaDetailSection(
            title: context.l10n.sunnahDuaPracticeLabel,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final point in points)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Text(
                      '• $point',
                      style: text.bodyMedium.copyWith(height: 1.6),
                    ),
                  ),
                SelectableText(
                  practice,
                  style: text.bodyMedium.copyWith(height: 1.6),
                ),
              ],
            ),
          ),
        if (!entry.note.isEmpty)
          DuaDetailSection(
            title: context.l10n.sunnahDuaAuthenticityLabel,
            child: SelectableText(
              entry.note.inLanguage(language),
              style: text.bodyMedium.copyWith(height: 1.6),
            ),
          ),
        if (entry.variants.isNotEmpty)
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(context.l10n.duaAlternativeWording),
            children: [
              for (final variant in entry.variants)
                DuaReadingPanel(passage: variant),
            ],
          ),
        if (referenceParts.isNotEmpty || entry.referenceVariant != null)
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(context.l10n.duaContextWording),
            children: [
              if (entry.referenceVariant case final variant?)
                DuaReadingPanel(passage: variant),
              for (final part in referenceParts) DuaReadingPanel(passage: part),
            ],
          ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

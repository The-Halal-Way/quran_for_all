import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/dua/dua_catalog.dart';
import 'dua_catalog_visuals.dart';
import 'dua_source_link.dart';

class DuaReadingPanel extends StatelessWidget {
  const DuaReadingPanel({super.key, required this.passage, this.fallbackCount});
  final DuaPassage passage;
  final int? fallbackCount;

  @override
  Widget build(BuildContext context) {
    final language = context.l10n.localeName;
    final scheme = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    final count = passage.repetitions ?? fallbackCount;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: scheme.primary.withValues(alpha: .16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!passage.label.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                passage.label.inLanguage(language),
                style: text.titleSmall.copyWith(color: scheme.primary),
              ),
            ),
          if (count != null)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Chip(
                avatar: const Icon(Icons.repeat_rounded, size: 17),
                label: Text(
                  context.l10n.duaRepeatCount(duaNumber(context, count)),
                ),
              ),
            ),
          SelectableText(
            passage.arabic,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: AppTheme.amiri(
              context,
              fontSize: 29,
              color: scheme.onSurface,
              height: 1.8,
            ),
          ),
          if (!passage.pronunciation.isEmpty) ...[
            const Divider(height: AppSpacing.xxxl),
            Text(
              context.l10n.sunnahDuaPronunciationLabel,
              style: text.labelSmall.copyWith(
                color: scheme.primary,
                fontWeight: AppTheme.weightBold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SelectableText(
              passage.pronunciation.inLanguage(language),
              style: text.duahCardBodyItalic.copyWith(height: 1.6),
            ),
          ],
          if (!passage.meaning.isEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.l10n.sunnahDuaTranslationLabel,
              style: text.labelSmall.copyWith(
                color: scheme.primary,
                fontWeight: AppTheme.weightBold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SelectableText(
              passage.meaning.inLanguage(language),
              style: text.duahCardBody.copyWith(height: 1.65),
            ),
          ],
          if (passage.quranReference.isNotEmpty)
            DuaSourceLink(
              label: duaQuranLabel(context, passage.quranReference),
              url: duaString(passage.quranReference['url']),
            ),
          if (passage.sourceUrl.isNotEmpty)
            DuaSourceLink(
              label: context.l10n.sunnahDuaSourceLabel,
              url: passage.sourceUrl,
            ),
        ],
      ),
    );
  }
}

String duaQuranLabel(BuildContext context, DuaJson reference) {
  final start = '${reference['surah']}:${reference['ayah']}';
  final range = reference['endAyah'] == null
      ? start
      : '$start–${reference['endAyah']}';
  return reference['readerOnlyForFullRecitation'] == true
      ? '${context.l10n.duaReadFullVerses} · $range'
      : '${context.l10n.sunnahDuaKindQuranAyah} $range';
}

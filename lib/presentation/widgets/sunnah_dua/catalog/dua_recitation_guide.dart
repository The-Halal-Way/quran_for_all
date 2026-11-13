import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/models/dua/dua_catalog.dart';
import 'dua_detail_section.dart';
import 'dua_source_link.dart';

Future<void> showDuaRecitationGuide(
  BuildContext context,
  DuaCatalog catalog, {
  DuaEntry? entry,
}) => showModalBottomSheet<void>(
  context: context,
  useSafeArea: true,
  showDragHandle: true,
  isScrollControlled: true,
  constraints: BoxConstraints(
    maxWidth: AppResponsive.of(context).maxSheetWidth,
  ),
  builder: (_) => SizedBox(
    height: MediaQuery.sizeOf(context).height * .82,
    child: DuaRecitationGuide(catalog: catalog, entry: entry),
  ),
);

class DuaRecitationGuide extends StatelessWidget {
  const DuaRecitationGuide({super.key, required this.catalog, this.entry});
  final DuaCatalog catalog;
  final DuaEntry? entry;

  @override
  Widget build(BuildContext context) {
    final guide = catalog.guide;
    final language = context.l10n.localeName;
    final text = AppTheme.text(context);
    final examples = entry == null
        ? const <DuaJson>[]
        : duaObjects(entry!.recitation['longVowelExamples']);
    final soundIds = entry == null
        ? const <String>[]
        : duaIds(entry!.recitation['makhrajSoundIds']);
    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.xxl,
        ),
        children: [
          Text(
            DuaText(guide['title']).inLanguage(language),
            style: text.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            DuaText(guide['intro']).inLanguage(language),
            style: text.bodyMedium.copyWith(height: 1.6),
          ),
          const SizedBox(height: AppSpacing.xl),
          if (entry != null && !DuaText(entry!.recitation['note']).isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Text(
                DuaText(entry!.recitation['note']).inLanguage(language),
                style: text.bodyMedium,
              ),
            ),
          for (final vowel in duaObjects(guide['longVowels']))
            DuaDetailSection(
              title: '${vowel['sound']} · ${vowel['banglaCue']}',
              child: Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.sm,
                children: [
                  Text(
                    duaString(vowel['exampleArabic']),
                    style: AppTheme.amiri(context, fontSize: 26),
                  ),
                  Text(
                    DuaText(vowel['examplePronunciation']).inLanguage(language),
                    style: text.bodyMedium,
                  ),
                  for (final example in examples.where(
                    (example) => example['vowelId'] == vowel['id'],
                  ))
                    Text(
                      duaString(example['word']),
                      style: AppTheme.amiri(context, fontSize: 26),
                    ),
                ],
              ),
            ),
          for (final key in ['maddNote', 'shaddahNote', 'pauseNote']) ...[
            SelectableText(
              DuaText(guide[key]).inLanguage(language),
              style: text.bodyMedium.copyWith(height: 1.6),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          for (final sound in duaObjects(guide['sounds']))
            if (entry == null || soundIds.contains(sound['id']))
              DuaDetailSection(
                title:
                    '${sound['letter']} · ${sound['latin']} · ${DuaText(sound['title']).inLanguage(language)}',
                child: Text(
                  DuaText(sound['howToSay']).inLanguage(language),
                  style: text.bodyMedium.copyWith(height: 1.6),
                ),
              ),
          for (final reference in duaObjects(guide['references']))
            DuaSourceLink(
              label: DuaText(reference['title']).inLanguage(language),
              url: duaString(reference['url']),
            ),
        ],
      ),
    );
  }
}

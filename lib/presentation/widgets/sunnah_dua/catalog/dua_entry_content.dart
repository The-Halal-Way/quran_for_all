import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/models/dua/dua_catalog.dart';
import '../../common/app_page_scrollbar.dart';
import 'dua_detail_section.dart';
import 'dua_entry_context.dart';
import 'dua_entry_heading.dart';
import 'insights/dua_entry_introduction.dart';
import 'insights/dua_entry_background.dart';
import 'dua_entry_sources.dart';
import 'dua_occasion_selector.dart';
import 'dua_reading_panel.dart';
import 'dua_recitation_guide.dart';
import 'dua_source_link.dart';

class DuaEntryContent extends StatelessWidget {
  const DuaEntryContent({
    super.key,
    required this.catalog,
    required this.entry,
    required this.occasion,
    required this.onOccasionSelected,
    required this.onRelatedSelected,
    this.categoryId,
  });

  final DuaCatalog catalog;
  final DuaEntry entry;
  final String? categoryId, occasion;
  final ValueChanged<String> onOccasionSelected;
  final ValueChanged<DuaEntry> onRelatedSelected;

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    return AppPageScrollbar(
      builder: (context, controller) => Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            key: PageStorageKey('dua-reading/${entry.id}'),
            controller: controller,
            padding: EdgeInsets.all(responsive.padding),
            children: [
              DuaEntryHeading(
                catalog: catalog,
                entry: entry,
                categoryId: categoryId,
              ),
              DuaEntryIntroduction(entry: entry),
              if (entry.hasOccasionSelector)
                DuaOccasionSelector(
                  entry: entry,
                  selected: occasion,
                  onSelected: onOccasionSelected,
                ),
              for (final passage in entry.passagesFor(occasion))
                DuaReadingPanel(
                  passage: passage,
                  fallbackCount: entry.segments.isEmpty
                      ? entry.practice.countFor(occasion)
                      : null,
                ),
              TextButton.icon(
                onPressed: () =>
                    showDuaRecitationGuide(context, catalog, entry: entry),
                icon: const Icon(Icons.record_voice_over_rounded, size: 19),
                label: Text(
                  DuaText(
                    catalog.guide['title'],
                  ).inLanguage(context.l10n.localeName),
                ),
              ),
              if (duaString(entry.recitation['listenUrl']).isNotEmpty)
                DuaSourceLink(
                  label: context.l10n.duaListenReference,
                  url: duaString(entry.recitation['listenUrl']),
                ),
              const SizedBox(height: AppSpacing.lg),
              DuaEntryBackground(entry: entry),
              DuaEntryContext(entry: entry),
              DuaEntrySources(
                entry: entry,
                description: DuaText(catalog.sourceNotes['sourceDescription']),
              ),
              if (entry.relatedIds.any(catalog.entries.containsKey))
                DuaDetailSection(
                  title: context.l10n.duaRelated,
                  child: Column(
                    children: [
                      for (final id in entry.relatedIds)
                        if (catalog.entries[id] case final related?)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              related.title.inLanguage(context.l10n.localeName),
                            ),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () => onRelatedSelected(related),
                          ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

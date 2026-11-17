import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/models/sunnah/sunnah_catalog.dart';
import '../../common/app_page_scrollbar.dart';
import '../catalog/dua_catalog_visuals.dart';
import '../catalog/dua_source_link.dart';
import 'sunnah_catalog_visuals.dart';
import 'sunnah_hadith_card.dart';

class SunnahEntryContent extends StatelessWidget {
  const SunnahEntryContent({
    super.key,
    required this.catalog,
    required this.entry,
    required this.onRelatedSelected,
    required this.onDuaSelected,
  });
  final SunnahCatalog catalog;
  final SunnahEntry entry;
  final ValueChanged<SunnahEntry> onRelatedSelected;
  final ValueChanged<String> onDuaSelected;

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    final language = context.l10n.localeName;
    final type = catalog.typeLabels[entry.type]?.inLanguage(language) ?? '';
    return AppPageScrollbar(
      builder: (context, controller) => Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            key: PageStorageKey('sunnah-reading/${entry.id}'),
            controller: controller,
            padding: EdgeInsets.all(responsive.padding),
            children: [
              _Hero(entry: entry, type: type, language: language),
              const SizedBox(height: AppSpacing.lg),
              _Section(
                title: context.l10n.sunnahHowToPractice,
                icon: Icons.spa_rounded,
                child: Text(
                  entry.practice.inLanguage(language),
                  style: AppTheme.text(
                    context,
                  ).bodyLarge.copyWith(height: 1.55),
                ),
              ),
              if (!entry.occasion.isEmpty || entry.repetitions.isNotEmpty)
                _Section(
                  title: context.l10n.sunnahOccasion,
                  icon: Icons.schedule_rounded,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!entry.occasion.isEmpty)
                        Text(entry.occasion.inLanguage(language)),
                      for (final count in entry.repetitions.entries)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            '${_occasion(count.key, language)}'
                            '${count.value == null ? '' : ' · ${duaNumber(context, count.value!)}×'}',
                          ),
                        ),
                    ],
                  ),
                ),
              if (entry.steps.isNotEmpty || entry.recitation.isNotEmpty)
                _Section(
                  title: context.l10n.sunnahPractice,
                  icon: Icons.format_list_numbered_rounded,
                  child: Column(
                    children: [
                      for (final (index, step) in entry.steps.indexed)
                        _Step(
                          number: index + 1,
                          text: step.inLanguage(language),
                        ),
                      for (final (index, step) in entry.recitation.indexed)
                        _Step(
                          number: index + 1,
                          text:
                              '${step.text.inLanguage(language)}'
                              '${step.repetitions == null ? '' : ' · ${duaNumber(context, step.repetitions!)}×'}',
                          onOpenDua: step.duaEntryId.isEmpty
                              ? null
                              : () => onDuaSelected(step.duaEntryId),
                        ),
                    ],
                  ),
                ),
              if (!entry.note.isEmpty)
                _Section(
                  title: context.l10n.sunnahImportantNote,
                  icon: Icons.info_outline_rounded,
                  accent: const Color(0xFFB97800),
                  child: Text(entry.note.inLanguage(language)),
                ),
              if (entry.linkedDuaIds.isNotEmpty)
                _Section(
                  title: context.l10n.sunnahRelatedDuas,
                  icon: Icons.auto_stories_rounded,
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final id in entry.linkedDuaIds)
                        ActionChip(
                          avatar: const Icon(Icons.menu_book_rounded, size: 17),
                          label: Text(context.l10n.sunnahOpenDua),
                          onPressed: () => onDuaSelected(id),
                        ),
                    ],
                  ),
                ),
              if (entry.quranReadingLinks.isNotEmpty)
                _Section(
                  title: context.l10n.sunnahQuranReading,
                  icon: Icons.menu_book_rounded,
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final link in entry.quranReadingLinks)
                        if (link.url.isNotEmpty)
                          DuaSourceLink(
                            label: _quranLabel(context, link),
                            url: link.url,
                          ),
                    ],
                  ),
                ),
              if (entry.quranReferences.isNotEmpty)
                _Section(
                  title: context.l10n.sunnahQuranReferences,
                  icon: Icons.menu_book_outlined,
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final link in entry.quranReferences)
                        if (link.url.isNotEmpty)
                          DuaSourceLink(
                            label: _quranLabel(context, link),
                            url: link.url,
                          ),
                    ],
                  ),
                ),
              _Section(
                title: context.l10n.sunnahEvidence,
                icon: Icons.verified_rounded,
                child: Column(
                  children: [
                    for (final hadith in entry.hadith)
                      SunnahHadithCard(hadith: hadith),
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Text(
                        catalog.sourceNote.inLanguage(language),
                        style: AppTheme.text(context).labelSmall.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (entry.relatedIds.any(catalog.entries.containsKey))
                _Section(
                  title: context.l10n.duaRelated,
                  icon: Icons.hub_rounded,
                  child: Column(
                    children: [
                      for (final id in entry.relatedIds)
                        if (catalog.entries[id] case final related?)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(related.title.inLanguage(language)),
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

  String _occasion(String value, String language) {
    const bn = {
      'morning': 'সকাল',
      'evening': 'সন্ধ্যা',
      'bedtime': 'ঘুমের আগে',
    };
    const en = {
      'morning': 'Morning',
      'evening': 'Evening',
      'bedtime': 'Bedtime',
    };
    return (language.startsWith('bn') ? bn : en)[value] ?? value;
  }

  String _quranLabel(BuildContext context, SunnahQuranReference link) {
    final start =
        '${duaNumber(context, link.surah)}:${duaNumber(context, link.ayah)}';
    final range = link.endAyah == null
        ? start
        : '$start–${duaNumber(context, link.endAyah!)}';
    return link.repetitions == null
        ? range
        : '$range · ${duaNumber(context, link.repetitions!)}×';
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.entry,
    required this.type,
    required this.language,
  });
  final SunnahEntry entry;
  final String type, language;

  @override
  Widget build(BuildContext context) {
    final color = SunnahCatalogVisuals.color(
      entry.categoryIds.firstOrNull ?? '',
    );
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, Color.lerp(color, const Color(0xFF7657F5), .62)!],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            SunnahCatalogVisuals.icon(entry.categoryIds.firstOrNull ?? ''),
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: AppTheme.text(context).labelMedium.copyWith(
                    color: Colors.white70,
                    fontWeight: AppTheme.weightBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  entry.title.inLanguage(language),
                  style: AppTheme.text(context).headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: AppTheme.weightExtraBold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.child,
    this.accent,
  });
  final String title;
  final IconData icon;
  final Widget child;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = accent ?? scheme.primary;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Color.alphaBlend(color.withValues(alpha: .045), scheme.surface),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withValues(alpha: .16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.text(context).titleMedium.copyWith(
                    fontWeight: AppTheme.weightBold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text, this.onOpenDua});
  final int number;
  final String text;
  final VoidCallback? onOpenDua;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 13, child: Text(duaNumber(context, number))),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(text)),
        if (onOpenDua != null)
          IconButton(
            onPressed: onOpenDua,
            tooltip: context.l10n.sunnahOpenDua,
            icon: const Icon(Icons.menu_book_outlined, size: 20),
          ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../viewmodels/ruqyah/ruqyah_viewmodel.dart';
import '../shared/ruqyah_style.dart';

class RuqyahLibrary extends StatelessWidget {
  const RuqyahLibrary({super.key, required this.model, required this.onOpen});
  final RuqyahViewModel model;
  final void Function(List<String>, int) onOpen;
  @override
  Widget build(BuildContext context) {
    final entries = model.visibleReadings;
    final scheme = Theme.of(context).colorScheme;
    final accent = RuqyahStyle.accent(context);
    final categories = {
      'all': context.l10n.ruqyahAll,
      'extended': context.l10n.ruqyahExtendedPassages,
      'illness': context.l10n.ruqyahIllness,
      'bedtime': context.l10n.ruqyahBedtime,
      'children': context.l10n.ruqyahChildren,
      'protection': context.l10n.ruqyahProtection,
      'daily': context.l10n.ruqyahDaily,
      'distress': context.l10n.ruqyahDistress,
      'travel': context.l10n.ruqyahTravel,
      'visiting': context.l10n.ruqyahVisiting,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          key: const ValueKey('ruqyah-search'),
          initialValue: model.query,
          onChanged: (value) => model.filter(search: value),
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          textInputAction: TextInputAction.search,
          onFieldSubmitted: (_) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            hintText: context.l10n.ruqyahSearch,
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: scheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            for (final entry in categories.entries)
              ChoiceChip(
                label: Text(entry.value),
                selected: model.category == entry.key,
                onSelected: (_) => model.filter(selectedCategory: entry.key),
              ),
            FilterChip(
              label: Text(context.l10n.ruqyahBookmarks),
              avatar: const Icon(Icons.bookmark_outline_rounded, size: 17),
              selected: model.bookmarksOnly,
              onSelected: (value) => model.filter(saved: value),
            ),
          ],
        ),
        const SizedBox(height: 18),
        if (entries.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Text(
              context.l10n.ruqyahNoResults,
              textAlign: TextAlign.center,
            ),
          ),
        for (var i = 0; i < entries.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: scheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                side: BorderSide(color: scheme.outlineVariant),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => onOpen(entries.map((e) => e.id).toList(), i),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: .09),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(
                          entries[i].verseIds.isEmpty
                              ? Icons.favorite_outline_rounded
                              : Icons.menu_book_rounded,
                          color: accent,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entries[i].summary.title.inLanguage(
                                context.l10n.localeName,
                              ),
                              style: AppTheme.text(context).titleSmall.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              entries[i].context,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.text(context).bodySmall.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        model.bookmarks.contains(entries[i].id)
                            ? Icons.bookmark_rounded
                            : Icons.chevron_right_rounded,
                        color: accent,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

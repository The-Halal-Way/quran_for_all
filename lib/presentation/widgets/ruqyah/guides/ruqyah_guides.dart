import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/dua_search.dart';
import '../../../../data/models/ruqyah/ruqyah_guide.dart';
import 'ruqyah_guide_card.dart';

class RuqyahGuides extends StatefulWidget {
  const RuqyahGuides({
    super.key,
    required this.guides,
    required this.groups,
    required this.onOpen,
  });
  final List<RuqyahGuide> guides;
  final List<RuqyahGuideGroup> groups;
  final ValueChanged<String> onOpen;
  @override
  State<RuqyahGuides> createState() => _RuqyahGuidesState();
}

class _RuqyahGuidesState extends State<RuqyahGuides> {
  String _group = 'all', _query = '';
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final query = DuaSearch.normalize(_query);
    final visible = widget.guides
        .where(
          (guide) =>
              (_group == 'all' || guide.group == _group) &&
              DuaSearch.matches(guide.searchIndex, query),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.ruqyahKnowledgeTitle,
          style: AppTheme.text(
            context,
          ).titleLarge.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.ruqyahKnowledgeBody,
          style: AppTheme.text(
            context,
          ).bodyMedium.copyWith(height: 1.5, color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 18),
        TextField(
          key: const ValueKey('ruqyah-guide-search'),
          onChanged: (value) => setState(() => _query = value),
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: context.l10n.ruqyahSearchGuides,
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: scheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            ChoiceChip(
              label: Text(context.l10n.ruqyahAll),
              selected: _group == 'all',
              onSelected: (_) => setState(() => _group = 'all'),
            ),
            for (final group in widget.groups)
              ChoiceChip(
                label: Text(group.title.inLanguage(context.l10n.localeName)),
                selected: _group == group.id,
                onSelected: (_) => setState(() => _group = group.id),
              ),
          ],
        ),
        const SizedBox(height: 18),
        if (visible.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(context.l10n.ruqyahNoResults),
          ),
        for (final guide in visible)
          RuqyahGuideCard(
            title: guide.title,
            summary: guide.summary,
            basis: guide.basis,
            onTap: () => widget.onOpen(guide.id),
          ),
      ],
    );
  }
}

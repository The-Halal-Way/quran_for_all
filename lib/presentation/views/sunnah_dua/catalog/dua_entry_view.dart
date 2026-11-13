import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../../data/models/dua/dua_catalog.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/sunnah_dua/catalog/dua_entry_content.dart';
import '../../../widgets/sunnah_dua/catalog/dua_entry_copy_button.dart';
import '../../../widgets/sunnah_dua/catalog/dua_entry_navigation.dart';
import '../../../widgets/sunnah_dua/catalog/dua_language_button.dart';

class DuaEntryView extends StatefulWidget {
  const DuaEntryView({
    super.key,
    required this.catalog,
    required this.entry,
    this.categoryId,
    this.entryIds,
  });
  final DuaCatalog catalog;
  final DuaEntry entry;
  final String? categoryId;

  /// Full category order, independent of the library's temporary search query.
  /// Reference-note lists pass their own IDs so they remain a separate reader.
  final List<String>? entryIds;

  @override
  State<DuaEntryView> createState() => _DuaEntryViewState();
}

class _DuaEntryViewState extends State<DuaEntryView> {
  late final DuaCategory _category = widget.catalog.categories.firstWhere(
    (category) => category.id == widget.categoryId,
    orElse: () => widget.catalog.category(widget.catalog.allId),
  );
  late final List<DuaEntry> _entries;
  late final PageController _controller;
  final _occasions = <String, String>{};
  late int _index;

  @override
  void initState() {
    super.initState();
    _entries = _resolveEntries();
    _index = _entries.indexWhere((entry) => entry.id == widget.entry.id);
    _controller = PageController(initialPage: _index);
  }

  List<DuaEntry> _resolveEntries() {
    final ids =
        widget.entryIds ??
        (widget.entry.isDefault ? _category.entryIds : _category.referenceIds);
    final entries = [for (final id in ids.toSet()) ?widget.catalog.entries[id]];
    // A direct link outside this category remains readable without adding
    // unrelated entries to the category's ordered sequence.
    return List.unmodifiable(
      entries.any((entry) => entry.id == widget.entry.id)
          ? entries
          : [widget.entry],
    );
  }

  String? _occasionFor(DuaEntry entry) =>
      _occasions[entry.id] ??
      (entry.practice.occasions.contains(_category.id)
          ? _category.id
          : entry.practice.occasions.firstOrNull);

  void _goTo(int index) {
    if (index < 0 || index >= _entries.length || !_controller.hasClients) {
      return;
    }
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  void _openRelated(DuaEntry entry) {
    final index = _entries.indexWhere((item) => item.id == entry.id);
    if (index >= 0) {
      if (_controller.hasClients && (index - _index).abs() > 1) {
        _controller.jumpToPage(index);
      } else {
        _goTo(index);
      }
    } else {
      Navigator.of(context).push(
        AppPageRoute<void>(
          builder: (_) => DuaEntryView(catalog: widget.catalog, entry: entry),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = _entries[_index];
    return Scaffold(
      appBar: AppBar(
        title: Text(switch (current.type) {
          'sunnah_practice' => context.l10n.sunnahDuaKindSunnah,
          'dhikr' || 'quranic_remembrance' => context.l10n.sunnahDuaKindDhikr,
          _ => context.l10n.sunnahDuaKindDua,
        }),
        actions: [
          DuaEntryCopyButton(
            entry: current,
            categoryId: _category.id,
            occasion: _occasionFor(current),
          ),
          const DuaLanguageButton(),
        ],
      ),
      body: AppPremiumPageBackground(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _entries.length,
                allowImplicitScrolling: true,
                onPageChanged: (index) => setState(() => _index = index),
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  return DuaEntryContent(
                    key: ValueKey(entry.id),
                    catalog: widget.catalog,
                    entry: entry,
                    categoryId: _category.id,
                    occasion: _occasionFor(entry),
                    onOccasionSelected: (occasion) =>
                        setState(() => _occasions[entry.id] = occasion),
                    onRelatedSelected: _openRelated,
                  );
                },
              ),
            ),
            DuaEntryNavigation(
              index: _index,
              total: _entries.length,
              categoryTitle: _category.title.inLanguage(
                context.l10n.localeName,
              ),
              onPrevious: _index > 0 ? () => _goTo(_index - 1) : null,
              onNext: _index < _entries.length - 1
                  ? () => _goTo(_index + 1)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

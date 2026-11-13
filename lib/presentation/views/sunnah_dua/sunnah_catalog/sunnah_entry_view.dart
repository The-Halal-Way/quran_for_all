import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../../data/datasources/local/dua_catalog_loader.dart';
import '../../../../data/models/sunnah/sunnah_catalog.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/sunnah_dua/catalog/dua_language_button.dart';
import '../../../widgets/sunnah_dua/sunnah_catalog/sunnah_entry_content.dart';
import '../../../widgets/sunnah_dua/sunnah_catalog/sunnah_entry_navigation.dart';
import '../catalog/dua_entry_view.dart';

class SunnahEntryView extends StatefulWidget {
  const SunnahEntryView({
    super.key,
    required this.catalog,
    required this.entry,
    this.categoryId,
    this.entryIds,
  });
  final SunnahCatalog catalog;
  final SunnahEntry entry;
  final String? categoryId;
  final List<String>? entryIds;

  @override
  State<SunnahEntryView> createState() => _SunnahEntryViewState();
}

class _SunnahEntryViewState extends State<SunnahEntryView> {
  late final SunnahCategory _category = widget.catalog.categories.firstWhere(
    (category) => category.id == widget.categoryId,
    orElse: () => widget.catalog.category(widget.catalog.allId),
  );
  late final List<SunnahEntry> _entries = _resolveEntries();
  late int _index = _entries.indexWhere((entry) => entry.id == widget.entry.id);
  late final PageController _controller = PageController(initialPage: _index);
  bool _openingDua = false;

  List<SunnahEntry> _resolveEntries() {
    final entries = [
      for (final id in (widget.entryIds ?? _category.entryIds).toSet())
        ?widget.catalog.entries[id],
    ];
    return List.unmodifiable(
      entries.any((entry) => entry.id == widget.entry.id)
          ? entries
          : [widget.entry],
    );
  }

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

  void _openRelated(SunnahEntry entry) {
    final index = _entries.indexWhere((item) => item.id == entry.id);
    if (index >= 0) {
      if ((index - _index).abs() > 1) {
        _controller.jumpToPage(index);
      } else {
        _goTo(index);
      }
      return;
    }
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SunnahEntryView(catalog: widget.catalog, entry: entry),
      ),
    );
  }

  Future<void> _openDua(String id) async {
    if (_openingDua) return;
    setState(() => _openingDua = true);
    try {
      final catalog = await DuaCatalogLoader().load();
      final entry = catalog.entries[id];
      if (!mounted) return;
      if (entry == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.duaLoadFailed)));
        return;
      }
      final category = catalog.category(catalog.allId);
      await Navigator.of(context).push(
        AppPageRoute<void>(
          builder: (_) => DuaEntryView(
            catalog: catalog,
            entry: entry,
            categoryId: category.id,
            entryIds: category.entryIds,
          ),
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.duaLoadFailed)));
      }
    } finally {
      if (mounted) setState(() => _openingDua = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.sunnahPractice),
        actions: [
          if (_openingDua)
            const Padding(
              padding: EdgeInsets.all(14),
              child: SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
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
                  return SunnahEntryContent(
                    key: ValueKey(entry.id),
                    catalog: widget.catalog,
                    entry: entry,
                    onRelatedSelected: _openRelated,
                    onDuaSelected: _openDua,
                  );
                },
              ),
            ),
            SunnahEntryNavigation(
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

import 'package:flutter/foundation.dart';

import '../../../core/utils/dua_search.dart';
import '../../../data/datasources/local/sunnah_catalog_loader.dart';
import '../../../data/models/sunnah/sunnah_catalog.dart';

class SunnahLibraryViewModel extends ChangeNotifier {
  SunnahLibraryViewModel({SunnahCatalogLoader? loader, String? categoryId})
    : _loader = loader ?? SunnahCatalogLoader(),
      _categoryId = categoryId;

  final SunnahCatalogLoader _loader;
  SunnahCatalog? catalog;
  Object? error;
  bool loading = false;
  String? _categoryId;
  String _query = '';
  bool _disposed = false;

  String get query => _query;
  String? get categoryId => _categoryId;
  bool get showingCategories => _categoryId == null && _query.isEmpty;
  SunnahCategory get category => catalog!.category(
    _categoryId != null &&
            catalog!.categories.any((item) => item.id == _categoryId)
        ? _categoryId!
        : catalog!.allId,
  );

  List<SunnahEntry> get results {
    final data = catalog;
    if (data == null) return const [];
    final normalized = DuaSearch.normalize(_query);
    return [
      for (final id in category.entryIds)
        if (data.entries[id] case final entry?)
          if (normalized.isEmpty ||
              DuaSearch.matches(entry.searchIndex, normalized))
            entry,
    ];
  }

  Future<void> load() async {
    if (loading) return;
    loading = true;
    error = null;
    _notify();
    try {
      catalog = await _loader.load();
      if (_categoryId != null &&
          !catalog!.categories.any((item) => item.id == _categoryId)) {
        _categoryId = null;
      }
    } catch (caught) {
      error = caught;
    } finally {
      loading = false;
      _notify();
    }
  }

  void search(String value) {
    if (_query == value) return;
    _query = value;
    _notify();
  }

  void selectCategory(String? id, {bool clearSearch = true}) {
    _categoryId = id;
    if (clearSearch) _query = '';
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

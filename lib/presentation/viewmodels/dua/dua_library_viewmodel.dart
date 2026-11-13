import 'package:flutter/foundation.dart';

import '../../../core/utils/dua_search.dart';
import '../../../data/datasources/local/dua_catalog_loader.dart';
import '../../../data/models/dua/dua_catalog.dart';

class DuaLibraryViewModel extends ChangeNotifier {
  DuaLibraryViewModel({DuaCatalogLoader? loader, String? initialCategory})
    : _loader = loader ?? DuaCatalogLoader(),
      categoryId = initialCategory;

  final DuaCatalogLoader _loader;
  DuaCatalog? catalog;
  String? categoryId;
  String query = '';
  bool loading = true, failed = false, referenceOnly = false, _disposed = false;

  Future<void> load() async {
    loading = true;
    failed = false;
    notifyListeners();
    try {
      final loaded = await _loader.load();
      if (_disposed) return;
      catalog = loaded;
      if (!loaded.categories.any((category) => category.id == categoryId)) {
        categoryId = null;
      }
    } catch (_) {
      if (!_disposed) failed = true;
    } finally {
      if (!_disposed) {
        loading = false;
        notifyListeners();
      }
    }
  }

  bool get showingCategories => categoryId == null && query.trim().isEmpty;
  DuaCategory get category => catalog!.category(categoryId ?? catalog!.allId);

  List<DuaEntry> get results =>
      _matches(referenceOnly ? category.referenceIds : category.entryIds);
  int get mainMatchCount => _matches(category.entryIds).length;
  int get referenceMatchCount => _matches(category.referenceIds).length;

  List<DuaEntry> _matches(List<String> ids) {
    final needle = DuaSearch.normalize(query);
    return [
      for (final id in ids)
        if (DuaSearch.matches(catalog!.entries[id]!.searchIndex, needle))
          catalog!.entries[id]!,
    ];
  }

  void selectCategory(String? id, {bool clearSearch = true}) {
    categoryId = id;
    if (clearSearch) query = '';
    referenceOnly = false;
    notifyListeners();
  }

  void search(String text) {
    query = text;
    notifyListeners();
  }

  void showReferences(bool value) {
    referenceOnly = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

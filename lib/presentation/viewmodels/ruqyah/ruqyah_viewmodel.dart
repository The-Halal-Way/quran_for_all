import 'package:flutter/foundation.dart';

import '../../../core/utils/dua_search.dart';
import '../../../data/models/ruqyah/ruqyah_index.dart';
import '../../../data/models/ruqyah/ruqyah_progress.dart';
import '../../../data/models/ruqyah/ruqyah_reading.dart';
import '../../../data/repositories/ruqyah_repository.dart';

class RuqyahViewModel extends ChangeNotifier {
  RuqyahViewModel(this.repository);
  final RuqyahRepository repository;
  RuqyahIndex? index;
  Map<String, RuqyahReading>? readings;
  List<RuqyahGuide>? guides;
  bool loading = true,
      failed = false,
      contentLoading = false,
      contentFailed = false;
  bool _disposed = false;
  int tab = 0, _request = 0;
  String language = 'en', category = 'all', query = '';
  bool bookmarksOnly = false;
  RuqyahProgress? get progress => repository.store.progress;
  Set<String> get bookmarks => repository.store.bookmarks;

  Future<void> initialize() async {
    loading = true;
    failed = false;
    _notify();
    try {
      final result = await repository.assets.loadIndex();
      await repository.store.load();
      if (_disposed) return;
      index = result;
    } catch (_) {
      failed = true;
    }
    loading = false;
    _notify();
  }

  Future<void> selectTab(int value, String code) async {
    tab = value;
    language = code;
    contentFailed = false;
    final ticket = ++_request;
    contentLoading = value != 0;
    _notify();
    try {
      if (value == 1) {
        final result = await repository.assets.loadReadings(code);
        if (ticket == _request && !_disposed) readings = result;
      } else if (value == 2) {
        final result = await repository.assets.loadGuides(code);
        if (ticket == _request && !_disposed) guides = result;
      }
    } catch (_) {
      if (ticket == _request) contentFailed = true;
    }
    if (ticket != _request || _disposed) return;
    contentLoading = false;
    _notify();
  }

  List<RuqyahReading> get visibleReadings =>
      (readings?.values ?? <RuqyahReading>[])
          .where(
            (reading) =>
                (category == 'all' ||
                    reading.summary.categories.contains(category)) &&
                (!bookmarksOnly || bookmarks.contains(reading.id)) &&
                DuaSearch.matches(
                  reading.searchIndex,
                  DuaSearch.normalize(query),
                ),
          )
          .toList(growable: false);

  void filter({String? search, String? selectedCategory, bool? saved}) {
    query = search ?? query;
    category = selectedCategory ?? category;
    bookmarksOnly = saved ?? bookmarksOnly;
    _notify();
  }

  void refreshProgress() => _notify();
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

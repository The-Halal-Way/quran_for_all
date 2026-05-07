import 'package:flutter/foundation.dart';

import '../../../data/models/search_result_model.dart';
import '../../../data/models/surah_model.dart';
import '../../../domain/repositories/quran_repository.dart';

class SearchViewModel extends ChangeNotifier {
  SearchViewModel(this._quranRepository);

  final QuranRepository _quranRepository;

  bool _isLoading = false;
  String _query = '';
  String? _errorMessage;
  List<SearchResultModel> _results = const [];
  Map<int, SurahModel> _surahLookup = const {};

  bool get isLoading => _isLoading;
  String get query => _query;
  String? get errorMessage => _errorMessage;
  List<SearchResultModel> get results => _results;

  Future<void> initialize() async {
    final surahs = await _quranRepository.getAllSurahs();
    _surahLookup = {for (final surah in surahs) surah.id: surah};
  }

  SurahModel? surahById(int id) => _surahLookup[id];

  Future<void> search(String input) async {
    _query = input.trim();
    if (_query.isEmpty) {
      _results = const [];
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _results = await _quranRepository.search(_query);
    } catch (_) {
      _errorMessage = 'Search failed. Please try again.';
      _results = const [];
    }

    _isLoading = false;
    notifyListeners();
  }
}

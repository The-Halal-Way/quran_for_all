import 'package:flutter/foundation.dart';

import '../../../data/models/ayah_model.dart';
import '../../../data/models/last_read_model.dart';
import '../../../data/models/surah_model.dart';
import '../../../domain/repositories/quran_repository.dart';

class ReadQuranViewModel extends ChangeNotifier {
  ReadQuranViewModel(this._quranRepository);

  final QuranRepository _quranRepository;

  bool _isLoading = false;
  List<SurahModel> _surahs = const [];
  LastReadModel? _lastRead;
  AyahModel? _lastReadAyah;
  Set<int> _bookmarkedSurahIds = const <int>{};

  bool get isLoading => _isLoading;
  List<SurahModel> get surahs => _surahs;
  LastReadModel? get lastRead => _lastRead;
  AyahModel? get lastReadAyah => _lastReadAyah;
  Set<int> get bookmarkedSurahIds => _bookmarkedSurahIds;

  bool isSurahBookmarked(int surahId) => _bookmarkedSurahIds.contains(surahId);

  SurahModel? get lastReadSurah {
    final read = _lastRead;
    if (read == null) {
      return null;
    }

    for (final surah in _surahs) {
      if (surah.id == read.surahId) {
        return surah;
      }
    }

    return null;
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _surahs = await _quranRepository.getAllSurahs();
    _lastRead = await _quranRepository.getLastRead();
    _bookmarkedSurahIds = await _quranRepository.getBookmarkedSurahIds();

    final read = _lastRead;
    if (read != null) {
      _lastReadAyah = await _quranRepository.getAyah(
        read.surahId,
        read.ayahNumber,
      );
    } else {
      _lastReadAyah = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleSurahBookmark(SurahModel surah) async {
    final isBookmarked = _bookmarkedSurahIds.contains(surah.id);

    if (isBookmarked) {
      await _quranRepository.removeSurahBookmark(surah.id);
      _bookmarkedSurahIds = Set<int>.from(_bookmarkedSurahIds)
        ..remove(surah.id);
    } else {
      await _quranRepository.addSurahBookmark(surah.id);
      _bookmarkedSurahIds = Set<int>.from(_bookmarkedSurahIds)..add(surah.id);
    }

    notifyListeners();
  }
}

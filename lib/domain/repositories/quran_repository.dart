import '../../data/models/ayah_model.dart';
import '../../data/models/bookmark_model.dart';
import '../../data/models/last_read_model.dart';
import '../../data/models/search_result_model.dart';
import '../../data/models/surah_model.dart';

abstract class QuranRepository {
  Future<void> importDataIfNeeded({void Function(String status)? onProgress});

  Future<bool> hasLocalData();

  Future<List<SurahModel>> getAllSurahs();

  Future<List<AyahModel>> getAyahsBySurah(int surahId);

  Future<AyahModel?> getAyah(int surahId, int ayahNumber);

  Future<List<AyahModel>> getAyahsByJuz(int juz, {int limit = 80});

  Future<List<SearchResultModel>> search(String query);

  Future<void> saveLastRead(int surahId, int ayahNumber);

  Future<LastReadModel?> getLastRead();

  Future<void> addSurahBookmark(int surahId);

  Future<void> removeSurahBookmark(int surahId);

  Future<bool> isSurahBookmarked(int surahId);

  Future<Set<int>> getBookmarkedSurahIds();

  Future<void> addAyahBookmark(int surahId, int ayahNumber);

  Future<void> removeAyahBookmark(int surahId, int ayahNumber);

  Future<bool> isAyahBookmarked(int surahId, int ayahNumber);

  Future<Set<int>> getBookmarkedAyahNumbers(int surahId);

  Future<List<BookmarkModel>> getBookmarks();
}

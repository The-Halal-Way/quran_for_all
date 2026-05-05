import '../../data/models/ayah_model.dart';
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
}

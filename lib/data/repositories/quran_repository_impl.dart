import '../../core/constants/app_constants.dart';
import '../../data/datasources/local/app_database.dart';
import '../../data/datasources/remote/quran_api_service.dart';
import '../../data/models/ayah_model.dart';
import '../../data/models/bookmark_model.dart';
import '../../data/models/last_read_model.dart';
import '../../data/models/search_result_model.dart';
import '../../data/models/surah_model.dart';
import '../../domain/repositories/quran_repository.dart';

class QuranRepositoryImpl implements QuranRepository {
  QuranRepositoryImpl({
    required AppDatabase database,
    required QuranApiService apiService,
  }) : _database = database,
       _apiService = apiService;

  final AppDatabase _database;
  final QuranApiService _apiService;

  @override
  Future<void> importDataIfNeeded({
    void Function(String status)? onProgress,
  }) async {
    if (await _database.hasQuranData()) {
      return;
    }

    onProgress?.call('Downloading Arabic text...');
    final arabic = await _apiService.fetchEdition(AppConstants.arabicEdition);

    onProgress?.call('Downloading English translation...');
    final english = await _apiService.fetchEdition(AppConstants.englishEdition);

    onProgress?.call('Downloading Bangla translation...');
    final bangla = await _apiService.fetchEdition(AppConstants.banglaEdition);

    onProgress?.call('Downloading transliteration...');
    final transliterationEn = await _apiService.fetchEdition(
      AppConstants.transliterationEnEdition,
    );
    final transliterationBn = await _apiService.tryFetchEdition(
      AppConstants.transliterationBnEdition,
    );

    final arabicSurahs = _readSurahs(arabic);
    final englishSurahs = _readSurahs(english);
    final banglaSurahs = _readSurahs(bangla);
    final transliterationEnSurahs = _readSurahs(transliterationEn);
    final transliterationBnSurahs = transliterationBn == null
        ? const <Map<String, dynamic>>[]
        : _readSurahs(transliterationBn);

    final surahs = <SurahModel>[];
    final ayahs = <AyahModel>[];

    for (var s = 0; s < arabicSurahs.length; s++) {
      final arabicSurah = arabicSurahs[s];
      final surah = SurahModel.fromApi(arabicSurah);
      surahs.add(surah);

      final arabicAyahs = _readAyahs(arabicSurah);
      final englishAyahs = _readAyahsAt(englishSurahs, s);
      final banglaAyahs = _readAyahsAt(banglaSurahs, s);
      final transliterationEnAyahs = _readAyahsAt(transliterationEnSurahs, s);
      final transliterationBnAyahs = _readAyahsAt(transliterationBnSurahs, s);

      for (var a = 0; a < arabicAyahs.length; a++) {
        ayahs.add(
          AyahModel.fromMergedApi(
            surahId: surah.id,
            arabicAyah: arabicAyahs[a],
            englishTranslationAyah: _safeAt(englishAyahs, a),
            banglaTranslationAyah: _safeAt(banglaAyahs, a),
            transliterationEnAyah: _safeAt(transliterationEnAyahs, a),
            transliterationBnAyah:
                _safeAt(transliterationBnAyahs, a) ??
                _safeAt(transliterationEnAyahs, a),
            audioBaseUrl: AppConstants.audioBaseUrl,
          ),
        );
      }
    }

    onProgress?.call('Saving Quran in local storage...');
    await _database.insertQuranData(surahs: surahs, ayahs: ayahs);
  }

  @override
  Future<bool> hasLocalData() {
    return _database.hasQuranData();
  }

  @override
  Future<List<SurahModel>> getAllSurahs() {
    return _database.getAllSurahs();
  }

  @override
  Future<List<AyahModel>> getAyahsBySurah(int surahId) {
    return _database.getAyahsBySurah(surahId);
  }

  @override
  Future<AyahModel?> getAyah(int surahId, int ayahNumber) {
    return _database.getAyah(surahId, ayahNumber);
  }

  @override
  Future<List<AyahModel>> getAyahsByJuz(int juz, {int limit = 80}) {
    return _database.getAyahsByJuz(juz, limit: limit);
  }

  @override
  Future<void> saveLastRead(int surahId, int ayahNumber) {
    return _database.saveLastRead(surahId, ayahNumber);
  }

  @override
  Future<LastReadModel?> getLastRead() {
    return _database.getLastRead();
  }

  @override
  Future<void> addSurahBookmark(int surahId) {
    return _database.addBookmark(BookmarkModel.surah(surahId: surahId));
  }

  @override
  Future<void> removeSurahBookmark(int surahId) {
    return _database.removeBookmark(BookmarkType.surah, surahId: surahId);
  }

  @override
  Future<bool> isSurahBookmarked(int surahId) {
    return _database.isBookmarked(BookmarkType.surah, surahId: surahId);
  }

  @override
  Future<Set<int>> getBookmarkedSurahIds() {
    return _database.getBookmarkedSurahIds();
  }

  @override
  Future<void> addAyahBookmark(int surahId, int ayahNumber) {
    return _database.addBookmark(
      BookmarkModel.ayah(surahId: surahId, ayahNumber: ayahNumber),
    );
  }

  @override
  Future<void> removeAyahBookmark(int surahId, int ayahNumber) {
    return _database.removeBookmark(
      BookmarkType.ayah,
      surahId: surahId,
      ayahNumber: ayahNumber,
    );
  }

  @override
  Future<bool> isAyahBookmarked(int surahId, int ayahNumber) {
    return _database.isBookmarked(
      BookmarkType.ayah,
      surahId: surahId,
      ayahNumber: ayahNumber,
    );
  }

  @override
  Future<Set<int>> getBookmarkedAyahNumbers(int surahId) {
    return _database.getBookmarkedAyahNumbers(surahId);
  }

  @override
  Future<List<BookmarkModel>> getBookmarks() {
    return _database.getBookmarks();
  }

  @override
  Future<List<SearchResultModel>> search(String query) async {
    final cleaned = query.trim();
    if (cleaned.isEmpty) {
      return const [];
    }

    final results = <SearchResultModel>[];
    final surahResultIds = <int>{};
    final ayahResultIds = <int>{};

    final ayahRef = RegExp(
      r'^(\d{1,3})\s*[:.]\s*(\d{1,3})$',
    ).firstMatch(cleaned);
    if (ayahRef != null) {
      final surahId = int.parse(ayahRef.group(1)!);
      final ayahNumber = int.parse(ayahRef.group(2)!);
      final ayah = await _database.getAyah(surahId, ayahNumber);
      if (ayah != null && ayahResultIds.add(ayah.id)) {
        results.add(SearchResultModel.fromAyah(ayah));
      }
    }

    final juzRef = RegExp(
      r'^(juz|para)\s*(\d{1,2})$',
      caseSensitive: false,
    ).firstMatch(cleaned);
    if (juzRef != null) {
      final juz = int.parse(juzRef.group(2)!);
      final ayahs = await _database.getAyahsByJuz(juz, limit: 60);
      for (final ayah in ayahs) {
        if (ayahResultIds.add(ayah.id)) {
          results.add(SearchResultModel.fromAyah(ayah));
        }
      }
    }

    final surahMatches = await _database.searchSurahs(cleaned);
    for (final surah in surahMatches) {
      if (surahResultIds.add(surah.id)) {
        results.add(SearchResultModel.fromSurah(surah));
      }
    }

    if (cleaned.length > 1) {
      final ayahMatches = await _database.searchAyahsByKeyword(
        cleaned,
        limit: AppConstants.maxSearchResults,
      );
      for (final ayah in ayahMatches) {
        if (ayahResultIds.add(ayah.id)) {
          results.add(SearchResultModel.fromAyah(ayah));
        }
      }
    }

    if (results.length > AppConstants.maxSearchResults) {
      return results.take(AppConstants.maxSearchResults).toList();
    }

    return results;
  }

  List<Map<String, dynamic>> _readSurahs(Map<String, dynamic> data) {
    final raw = data['surahs'];
    if (raw is! List) {
      return const [];
    }

    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  List<Map<String, dynamic>> _readAyahsAt(
    List<Map<String, dynamic>> surahs,
    int index,
  ) {
    if (index < 0 || index >= surahs.length) {
      return const [];
    }

    return _readAyahs(surahs[index]);
  }

  List<Map<String, dynamic>> _readAyahs(Map<String, dynamic> surah) {
    final raw = surah['ayahs'];
    if (raw is! List) {
      return const [];
    }

    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Map<String, dynamic>? _safeAt(List<Map<String, dynamic>> list, int index) {
    if (index < 0 || index >= list.length) {
      return null;
    }
    return list[index];
  }
}

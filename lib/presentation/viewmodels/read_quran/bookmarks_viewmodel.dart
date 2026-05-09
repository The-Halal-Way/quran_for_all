import 'package:flutter/foundation.dart';

import '../../../core/localization/read_quran_message_localizer.dart';
import '../../../data/models/ayah_model.dart';
import '../../../data/models/bookmark_model.dart';
import '../../../data/models/surah_model.dart';
import '../../../domain/repositories/quran_repository.dart';

class BookmarksViewModel extends ChangeNotifier {
  BookmarksViewModel(this._quranRepository);

  final QuranRepository _quranRepository;

  bool _isLoading = false;
  String? _errorMessage;
  List<BookmarkModel> _bookmarks = const [];
  Map<int, SurahModel> _surahLookup = const {};
  Map<String, AyahModel> _ayahLookup = const {};

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<BookmarkModel> get bookmarks => _bookmarks;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final bookmarks = await _quranRepository.getBookmarks();
      final surahs = await _quranRepository.getAllSurahs();
      final surahLookup = {for (final surah in surahs) surah.id: surah};

      final ayahBookmarks = bookmarks
          .where((bookmark) => bookmark.type == BookmarkType.ayah)
          .toList();

      final ayahModels = await Future.wait(
        ayahBookmarks.map((bookmark) {
          final ayahNumber = bookmark.ayahNumber;
          if (ayahNumber == null) {
            return Future<AyahModel?>.value(null);
          }

          return _quranRepository.getAyah(bookmark.surahId, ayahNumber);
        }),
      );

      final ayahLookup = <String, AyahModel>{};
      for (var i = 0; i < ayahBookmarks.length; i++) {
        final bookmark = ayahBookmarks[i];
        final ayah = ayahModels[i];
        final ayahNumber = bookmark.ayahNumber;

        if (ayah != null && ayahNumber != null) {
          ayahLookup[_ayahKey(bookmark.surahId, ayahNumber)] = ayah;
        }
      }

      _bookmarks = bookmarks;
      _surahLookup = surahLookup;
      _ayahLookup = ayahLookup;
    } catch (_) {
      _errorMessage = ReadQuranMessageKeys.unableLoadBookmarks;
      _bookmarks = const [];
      _surahLookup = const {};
      _ayahLookup = const {};
    }

    _isLoading = false;
    notifyListeners();
  }

  SurahModel? surahFor(int surahId) => _surahLookup[surahId];

  AyahModel? ayahFor(int surahId, int ayahNumber) {
    return _ayahLookup[_ayahKey(surahId, ayahNumber)];
  }

  String _ayahKey(int surahId, int ayahNumber) => '$surahId:$ayahNumber';
}

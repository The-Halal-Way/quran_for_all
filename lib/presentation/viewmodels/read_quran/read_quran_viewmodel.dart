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

  bool get isLoading => _isLoading;
  List<SurahModel> get surahs => _surahs;
  LastReadModel? get lastRead => _lastRead;
  AyahModel? get lastReadAyah => _lastReadAyah;

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

    final read = _lastRead;
    if (read != null) {
      _lastReadAyah = await _quranRepository.getAyah(
        read.surahId,
        read.ayahNumber,
      );
    }

    _isLoading = false;
    notifyListeners();
  }
}

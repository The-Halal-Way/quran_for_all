import 'package:flutter/foundation.dart';

import '../../data/models/ayah_model.dart';
import '../../data/models/surah_model.dart';
import '../../domain/repositories/audio_repository.dart';
import '../../domain/repositories/quran_repository.dart';

class SurahDetailsViewModel extends ChangeNotifier {
  SurahDetailsViewModel({
    required this.surah,
    required QuranRepository quranRepository,
    required AudioRepository audioRepository,
  }) : _quranRepository = quranRepository,
       _audioRepository = audioRepository;

  final SurahModel surah;
  final QuranRepository _quranRepository;
  final AudioRepository _audioRepository;

  bool _isLoading = false;
  bool _isPlayingFullSurah = false;
  String? _errorMessage;
  List<AyahModel> _ayahs = const [];

  bool get isLoading => _isLoading;
  bool get isPlayingFullSurah => _isPlayingFullSurah;
  String? get errorMessage => _errorMessage;
  List<AyahModel> get ayahs => _ayahs;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _ayahs = await _quranRepository.getAyahsBySurah(surah.id);
    } catch (_) {
      _errorMessage = 'Unable to load ayahs for this surah.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> playAyah(AyahModel ayah) async {
    await _audioRepository.playAyah(ayah);
    await _quranRepository.saveLastRead(ayah.surahId, ayah.ayahNumber);
  }

  Future<void> playFullSurah() async {
    if (_ayahs.isEmpty || _isPlayingFullSurah) {
      return;
    }

    _isPlayingFullSurah = true;
    notifyListeners();

    try {
      await _audioRepository.playSurah(_ayahs);
    } finally {
      _isPlayingFullSurah = false;
      notifyListeners();
    }
  }

  Future<void> stopPlayback() async {
    await _audioRepository.stop();
    _isPlayingFullSurah = false;
    notifyListeners();
  }

  Future<void> markAsLastRead(AyahModel ayah) {
    return _quranRepository.saveLastRead(ayah.surahId, ayah.ayahNumber);
  }
}

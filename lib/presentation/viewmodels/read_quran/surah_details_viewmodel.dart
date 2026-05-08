import 'package:flutter/foundation.dart';

import '../../../core/enums/playback_source.dart';
import '../../../core/localization/read_quran_message_localizer.dart';
import '../../../data/models/ayah_model.dart';
import '../../../data/models/surah_model.dart';
import '../../../domain/repositories/audio_repository.dart';
import '../../../domain/repositories/quran_repository.dart';
import '../audio_control_viewmodel.dart';

class SurahDetailsViewModel extends ChangeNotifier {
  SurahDetailsViewModel({
    required QuranRepository quranRepository,
    required AudioRepository audioRepository,
    required AudioControlViewModel audioControlViewModel,
  }) : _quranRepository = quranRepository,
       _audioRepository = audioRepository,
       _audioControl = audioControlViewModel;

  SurahModel? _surah;
  final QuranRepository _quranRepository;
  final AudioRepository _audioRepository;
  final AudioControlViewModel _audioControl;

  bool _isLoading = false;
  bool _isPlayingFullSurah = false;
  String? _errorMessage;
  List<AyahModel> _ayahs = const [];
  int _loadRequestId = 0;

  SurahModel? get surah => _surah;
  bool get isLoading => _isLoading;
  bool get isPlayingFullSurah => _isPlayingFullSurah;
  String? get errorMessage => _errorMessage;
  List<AyahModel> get ayahs => _ayahs;

  Future<void> openSurah(SurahModel surah) async {
    _surah = surah;
    await load();
  }

  Future<void> load() async {
    final selectedSurah = _surah;
    if (selectedSurah == null) {
      _errorMessage = ReadQuranMessageKeys.noSurahSelected;
      _ayahs = const [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    final requestId = ++_loadRequestId;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ayahs = await _quranRepository.getAyahsBySurah(selectedSurah.id);
      if (requestId != _loadRequestId) {
        return;
      }

      _ayahs = ayahs;
    } catch (_) {
      if (requestId != _loadRequestId) {
        return;
      }

      _errorMessage = ReadQuranMessageKeys.unableLoadAyahs;
    }

    if (requestId != _loadRequestId) {
      return;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> playAyah(AyahModel ayah) async {
    _audioControl.setPlaybackContext(
      source: PlaybackSource.surahDetails,
      title: _surah?.nameEnglish ?? 'Surah',
      subtitle: 'Ayah ${ayah.ayahNumber}',
    );
    await _audioRepository.playAyah(ayah);
    await _quranRepository.saveLastRead(ayah.surahId, ayah.ayahNumber);
  }

  Future<void> playFullSurah() async {
    if (_ayahs.isEmpty || _isPlayingFullSurah) {
      return;
    }

    _isPlayingFullSurah = true;
    notifyListeners();

    _audioControl.setPlaybackContext(
      source: PlaybackSource.surahDetails,
      title: _surah?.nameEnglish ?? 'Surah',
      subtitle: 'Full surah · ${_ayahs.length} ayahs',
    );

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

import 'dart:async';

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
       _audioControl = audioControlViewModel {
    _isPlayingSubscription = _audioRepository.isPlayingStream.listen((isPlaying) {
      if (!isPlaying && _playingAyahNumber != null) {
        _playingAyahNumber = null;
        notifyListeners();
      }
    });
  }

  SurahModel? _surah;
  final QuranRepository _quranRepository;
  final AudioRepository _audioRepository;
  final AudioControlViewModel _audioControl;
  late final StreamSubscription<bool> _isPlayingSubscription;

  bool _isLoading = false;
  bool _isPlayingFullSurah = false;
  int? _playingAyahNumber;
  String? _errorMessage;
  List<AyahModel> _ayahs = const [];
  Set<int> _bookmarkedAyahNumbers = const <int>{};
  int _loadRequestId = 0;

  SurahModel? get surah => _surah;
  bool get isLoading => _isLoading;
  bool get isPlayingFullSurah => _isPlayingFullSurah;
  int? get playingAyahNumber => _playingAyahNumber;
  String? get errorMessage => _errorMessage;
  List<AyahModel> get ayahs => _ayahs;
  Set<int> get bookmarkedAyahNumbers => _bookmarkedAyahNumbers;

  bool isAyahPlaying(int ayahNumber) => _playingAyahNumber == ayahNumber;

  bool isAyahBookmarked(int ayahNumber) {
    return _bookmarkedAyahNumbers.contains(ayahNumber);
  }

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
      final bookmarkedAyahs = await _quranRepository.getBookmarkedAyahNumbers(
        selectedSurah.id,
      );
      if (requestId != _loadRequestId) {
        return;
      }

      _ayahs = ayahs;
      _bookmarkedAyahNumbers = bookmarkedAyahs;
    } catch (_) {
      if (requestId != _loadRequestId) {
        return;
      }

      _errorMessage = ReadQuranMessageKeys.unableLoadAyahs;
      _bookmarkedAyahNumbers = const <int>{};
    }

    if (requestId != _loadRequestId) {
      return;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> playAyah(AyahModel ayah) async {
    // If full-surah playback is in progress, abort it before starting a
    // single-ayah play; otherwise the surah loop would keep running in the
    // background after the individual ayah finishes.
    if (_isPlayingFullSurah) {
      await _audioRepository.stop();
      _isPlayingFullSurah = false;
      _playingAyahNumber = null;
      notifyListeners();
    }

    _playingAyahNumber = ayah.ayahNumber;
    notifyListeners();

    _audioControl.setPlaybackContext(
      source: PlaybackSource.surahDetails,
      title: _surah?.nameEnglish ?? 'Surah',
      subtitle: 'Ayah ${ayah.ayahNumber}',
    );
    try {
      await _audioRepository.playAyah(ayah);
      await _quranRepository.saveLastRead(ayah.surahId, ayah.ayahNumber);
    } catch (_) {
      if (_playingAyahNumber == ayah.ayahNumber) {
        _playingAyahNumber = null;
        notifyListeners();
      }
      rethrow;
    } finally {
      if (_playingAyahNumber == ayah.ayahNumber) {
        _playingAyahNumber = null;
        notifyListeners();
      }
    }
  }

  Future<void> playFullSurah() async {
    if (_ayahs.isEmpty || _isPlayingFullSurah) {
      return;
    }

  _playingAyahNumber = null;
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
    _playingAyahNumber = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _isPlayingSubscription.cancel();
    super.dispose();
  }

  Future<void> markAsLastRead(AyahModel ayah) {
    return _quranRepository.saveLastRead(ayah.surahId, ayah.ayahNumber);
  }

  Future<void> toggleAyahBookmark(AyahModel ayah) async {
    final isBookmarked = _bookmarkedAyahNumbers.contains(ayah.ayahNumber);

    if (isBookmarked) {
      await _quranRepository.removeAyahBookmark(ayah.surahId, ayah.ayahNumber);
      _bookmarkedAyahNumbers = Set<int>.from(_bookmarkedAyahNumbers)
        ..remove(ayah.ayahNumber);
    } else {
      await _quranRepository.addAyahBookmark(ayah.surahId, ayah.ayahNumber);
      _bookmarkedAyahNumbers = Set<int>.from(_bookmarkedAyahNumbers)
        ..add(ayah.ayahNumber);
    }

    notifyListeners();
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/enums/playback_source.dart';
import '../../../core/enums/app_language.dart';
import '../../../core/localization/read_quran_message_localizer.dart';
import '../../../core/quran/quran_bismillah.dart';
import '../../../data/models/ayah_model.dart';
import '../../../data/models/surah_opening_model.dart';
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
    _isPlayingSubscription = _audioRepository.isPlayingStream.listen((
      isPlaying,
    ) {
      if (!isPlaying && (_playingAyahNumber != null || _isPlayingBismillah)) {
        _playingAyahNumber = null;
        _isPlayingBismillah = false;
        notifyListeners();
      }
    });

    // During full-surah playback, the audio service announces the ayah
    // about to play so its Arabic text can be highlighted, mirroring the
    // single-ayah highlight behavior.
    _currentAyahNumberSubscription = _audioRepository.currentAyahNumberStream
        .listen((ayahNumber) {
          if (_isPlayingFullSurah) {
            _isPlayingBismillah = ayahNumber == 0;
            _playingAyahNumber = ayahNumber == 0 ? null : ayahNumber;
            notifyListeners();
          }
        });
  }

  SurahModel? _surah;
  final QuranRepository _quranRepository;
  final AudioRepository _audioRepository;
  final AudioControlViewModel _audioControl;
  late final StreamSubscription<bool> _isPlayingSubscription;
  late final StreamSubscription<int> _currentAyahNumberSubscription;

  bool _isLoading = false;
  bool _isPlayingFullSurah = false;
  bool _isPlayingBismillah = false;
  SurahOpeningModel? _openingBismillah;
  int? _playingAyahNumber;
  int? _lastReadAyahNumber;
  String? _errorMessage;
  List<AyahModel> _ayahs = const [];
  Set<int> _bookmarkedAyahNumbers = const <int>{};
  int _loadRequestId = 0;
  int _playbackRequestId = 0;

  SurahModel? get surah => _surah;
  bool get isLoading => _isLoading;
  bool get isPlayingFullSurah => _isPlayingFullSurah;
  bool get isPlayingBismillah => _isPlayingBismillah;
  SurahOpeningModel? get openingBismillah => _openingBismillah;
  int? get playingAyahNumber => _playingAyahNumber;
  int? get lastReadAyahNumber => _lastReadAyahNumber;
  String? get errorMessage => _errorMessage;
  List<AyahModel> get ayahs => _ayahs;
  Set<int> get bookmarkedAyahNumbers => _bookmarkedAyahNumbers;

  bool isAyahPlaying(int ayahNumber) => _playingAyahNumber == ayahNumber;

  bool isAyahBookmarked(int ayahNumber) {
    return _bookmarkedAyahNumbers.contains(ayahNumber);
  }

  bool isLastReadAyah(int ayahNumber) => _lastReadAyahNumber == ayahNumber;

  Future<AyahTranslation?> loadAdditionalTranslation(
    AyahModel ayah,
    AppLanguage language,
  ) async {
    final fullAyah = await _quranRepository.getAyah(
      ayah.surahId,
      ayah.ayahNumber,
    );
    return (fullAyah ?? ayah).additionalTranslationFor(language);
  }

  Future<void> openSurah(SurahModel surah) async {
    final requestId = ++_loadRequestId;
    _surah = surah;
    _ayahs = const [];
    _openingBismillah = null;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (_isPlayingFullSurah ||
        _isPlayingBismillah ||
        _playingAyahNumber != null) {
      await stopPlayback();
    }
    if (requestId != _loadRequestId) return;
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
    final shouldNotifyLoading = !_isLoading || _errorMessage != null;
    _isLoading = true;
    _errorMessage = null;
    if (shouldNotifyLoading) notifyListeners();

    try {
      final ayahs = await _quranRepository.getAyahsBySurah(selectedSurah.id);
      final openingAyah = QuranBismillah.hasSeparateOpening(selectedSurah.id)
          ? await _quranRepository.getAyah(1, 1)
          : null;
      final bookmarkedAyahs = await _quranRepository.getBookmarkedAyahNumbers(
        selectedSurah.id,
      );
      final lastRead = await _quranRepository.getLastRead();
      if (requestId != _loadRequestId) {
        return;
      }

      _ayahs = ayahs;
      _openingBismillah = openingAyah == null
          ? null
          : SurahOpeningModel(source: openingAyah, surahId: selectedSurah.id);
      _bookmarkedAyahNumbers = bookmarkedAyahs;
      _lastReadAyahNumber =
          lastRead != null && lastRead.surahId == selectedSurah.id
          ? lastRead.ayahNumber
          : null;
    } catch (_) {
      if (requestId != _loadRequestId) {
        return;
      }

      _errorMessage = ReadQuranMessageKeys.unableLoadAyahs;
      _bookmarkedAyahNumbers = const <int>{};
      _lastReadAyahNumber = null;
    }

    if (requestId != _loadRequestId) {
      return;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> playAyah(AyahModel ayah) async {
    await _playSingle(ayah);
  }

  Future<void> playBismillah() async {
    final opening = _openingBismillah;
    if (opening == null) return;
    await _playSingle(opening.playbackEntry, isBismillah: true);
  }

  Future<void> _playSingle(AyahModel ayah, {bool isBismillah = false}) async {
    final requestId = ++_playbackRequestId;
    if (_isPlayingFullSurah ||
        _isPlayingBismillah ||
        _playingAyahNumber != null ||
        _audioRepository.isPlaying ||
        _audioRepository.isPaused) {
      await _audioRepository.stop();
      if (requestId != _playbackRequestId) return;
    }

    _isPlayingFullSurah = false;
    _isPlayingBismillah = isBismillah;
    _playingAyahNumber = isBismillah ? null : ayah.ayahNumber;
    notifyListeners();

    _audioControl.setPlaybackContext(
      source: PlaybackSource.surahDetails,
      title: _surah?.nameEnglish ?? 'Surah',
      subtitle: isBismillah ? 'Bismillah' : 'Ayah ${ayah.ayahNumber}',
    );
    try {
      await _audioRepository.playAyah(ayah);
      if (!isBismillah && requestId == _playbackRequestId) {
        await _quranRepository.saveLastRead(ayah.surahId, ayah.ayahNumber);
        if (requestId == _playbackRequestId &&
            _lastReadAyahNumber != ayah.ayahNumber) {
          _lastReadAyahNumber = ayah.ayahNumber;
          notifyListeners();
        }
      }
    } finally {
      if (requestId == _playbackRequestId) {
        _playingAyahNumber = null;
        _isPlayingBismillah = false;
        notifyListeners();
      }
    }
  }

  Future<void> playFullSurah() async {
    if (_ayahs.isEmpty || _isPlayingFullSurah) {
      return;
    }

    final requestId = ++_playbackRequestId;
    if (_isPlayingBismillah ||
        _playingAyahNumber != null ||
        _audioRepository.isPlaying ||
        _audioRepository.isPaused) {
      await _audioRepository.stop();
      if (requestId != _playbackRequestId) return;
    }

    _playingAyahNumber = null;
    _isPlayingBismillah = false;
    _isPlayingFullSurah = true;
    notifyListeners();

    _audioControl.setPlaybackContext(
      source: PlaybackSource.surahDetails,
      title: _surah?.nameEnglish ?? 'Surah',
      subtitle: 'Full surah · ${_ayahs.length} ayahs',
    );

    try {
      await _audioRepository.playSurah([
        if (_openingBismillah case final opening?) opening.playbackEntry,
        ..._ayahs,
      ]);
    } finally {
      if (requestId == _playbackRequestId) {
        _isPlayingFullSurah = false;
        _isPlayingBismillah = false;
        _playingAyahNumber = null;
        notifyListeners();
      }
    }
  }

  Future<void> stopPlayback() async {
    ++_playbackRequestId;
    _isPlayingFullSurah = false;
    _isPlayingBismillah = false;
    _playingAyahNumber = null;
    notifyListeners();
    await _audioRepository.stop();
  }

  @override
  void dispose() {
    ++_loadRequestId;
    ++_playbackRequestId;
    _isPlayingSubscription.cancel();
    _currentAyahNumberSubscription.cancel();
    super.dispose();
  }

  Future<void> markAsLastRead(AyahModel ayah) async {
    await _quranRepository.saveLastRead(ayah.surahId, ayah.ayahNumber);
    if (_lastReadAyahNumber != ayah.ayahNumber) {
      _lastReadAyahNumber = ayah.ayahNumber;
      notifyListeners();
    }
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

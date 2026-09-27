import 'dart:async';

import 'package:quran_for_all/data/models/ayah_model.dart';
import 'package:quran_for_all/data/models/last_read_model.dart';
import 'package:quran_for_all/data/models/surah_model.dart';
import 'package:quran_for_all/domain/repositories/audio_repository.dart';
import 'package:quran_for_all/domain/repositories/quran_repository.dart';

const bismillahArabic = 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ';
const baqaraArabic = 'الٓمٓ';

AyahModel readerAyah({
  int id = 8,
  int surahId = 2,
  int number = 1,
  String arabic = '$bismillahArabic $baqaraArabic',
}) => AyahModel(
  id: id,
  surahId: surahId,
  ayahNumber: number,
  juzNumber: 1,
  hizbQuarter: 1,
  pageNumber: 2,
  arabicText: arabic,
  transliterationEn: id == 1
      ? 'Bismillaahir Rahmaanir Raheem'
      : 'Alif-Laam-Meem',
  transliterationBn: id == 1 ? 'বিসমিল্লাহির রাহমানির রাহিম' : 'আলিফ লাম মীম',
  translationEn: id == 1
      ? 'In the name of God, The Most Gracious, The Dispenser of Grace:'
      : 'Alif. Lam. Mim.',
  translationBn: id == 1
      ? 'পরম করুণাময় ও অসীম দয়ালু আল্লাহর নামে।'
      : 'আলিফ লাম মীম।',
  tafsirEn: '',
  tafsirBn: '',
  audioUrl: 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/$id.mp3',
);

SurahModel readerSurah(int id) => SurahModel(
  id: id,
  nameArabic: 'سورة',
  nameEnglish: 'Surah $id',
  nameTranslated: 'Surah $id',
  revelationType: 'Meccan',
  totalAyahs: 1,
);

class ReaderQuranRepository implements QuranRepository {
  final savedLastRead = <(int, int)>[];
  Set<int> bookmarks = {};

  @override
  Future<void> importDataIfNeeded({void Function(String)? onProgress}) async {}

  @override
  Future<List<AyahModel>> getAyahsBySurah(int surahId) async => [
    surahId == 1
        ? readerAyah(id: 1, surahId: 1, arabic: bismillahArabic)
        : surahId == 9
        ? readerAyah(id: 1236, surahId: 9, arabic: 'بَرَآءَةٌ')
        : readerAyah(surahId: surahId),
  ];

  @override
  Future<AyahModel?> getAyah(int surahId, int ayahNumber) async =>
      readerAyah(id: 1, surahId: 1, arabic: bismillahArabic);

  @override
  Future<Set<int>> getBookmarkedAyahNumbers(int surahId) async => bookmarks;

  @override
  Future<LastReadModel?> getLastRead() async => null;

  @override
  Future<void> saveLastRead(int surahId, int ayahNumber) async {
    savedLastRead.add((surahId, ayahNumber));
  }

  @override
  Future<void> addAyahBookmark(int surahId, int ayahNumber) async {
    bookmarks.add(ayahNumber);
  }

  @override
  Future<void> removeAyahBookmark(int surahId, int ayahNumber) async {
    bookmarks.remove(ayahNumber);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class ReaderAudioRepository implements AudioRepository {
  final playing = StreamController<bool>.broadcast(sync: true);
  final currentAyah = StreamController<int>.broadcast(sync: true);
  final positions = StreamController<Duration>.broadcast(sync: true);
  final durations = StreamController<Duration>.broadcast(sync: true);
  final tracks = <AyahModel>[];
  List<AyahModel> queue = [];
  Completer<void>? completion;
  bool failPlayback = false;
  Completer<void>? stopGate;
  int stopCalls = 0;
  bool _isPlaying = false;

  @override
  bool get isPlaying => _isPlaying;
  @override
  bool get isPaused => false;
  @override
  Stream<bool> get isPlayingStream => playing.stream;
  @override
  Stream<bool> get isPausedStream => const Stream.empty();
  @override
  Stream<Duration> get positionStream => positions.stream;
  @override
  Stream<Duration> get durationStream => durations.stream;
  @override
  Stream<int> get currentAyahNumberStream => currentAyah.stream;

  @override
  Future<void> playAyah(AyahModel ayah) {
    tracks.add(ayah);
    return _play();
  }

  @override
  Future<void> playSurah(List<AyahModel> ayahs, {int startIndex = 0}) {
    queue = ayahs.sublist(startIndex);
    currentAyah.add(queue.first.ayahNumber);
    return _play();
  }

  Future<void> _play() {
    if (failPlayback) return Future.error(StateError('Audio unavailable'));
    _isPlaying = true;
    playing.add(true);
    completion = Completer<void>();
    return completion!.future;
  }

  void finish() {
    _isPlaying = false;
    playing.add(false);
    if (completion != null && !completion!.isCompleted) completion!.complete();
    completion = null;
  }

  @override
  Future<void> stop() async {
    stopCalls++;
    finish();
    await stopGate?.future;
  }

  @override
  Future<void> pause() async {}
  @override
  Future<void> resume() async {}

  Future<void> dispose() async {
    finish();
    await playing.close();
    await currentAyah.close();
    await positions.close();
    await durations.close();
  }
}

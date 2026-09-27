import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/presentation/viewmodels/audio_control_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/read_quran/surah_details_viewmodel.dart';

import '../../support/quran_reader_fakes.dart';

void main() {
  late ReaderAudioRepository audio;
  late ReaderQuranRepository quran;
  late AudioControlViewModel controls;
  late SurahDetailsViewModel model;

  setUp(() {
    audio = ReaderAudioRepository();
    quran = ReaderQuranRepository();
    controls = AudioControlViewModel(audioRepository: audio);
    model = SurahDetailsViewModel(
      quranRepository: quran,
      audioRepository: audio,
      audioControlViewModel: controls,
    );
  });
  tearDown(() async {
    model.dispose();
    controls.dispose();
    await audio.dispose();
  });

  test(
    'Bismillah plays its own cached recording without saving verse zero',
    () async {
      await model.openSurah(readerSurah(2));
      final playback = model.playBismillah();
      await Future<void>.delayed(Duration.zero);
      expect(model.isPlayingBismillah, isTrue);
      expect(model.playingAyahNumber, isNull);
      expect(audio.tracks.single.id, 1);
      expect(audio.stopCalls, 0);
      expect(audio.tracks.single.audioUrl, endsWith('/1.mp3'));
      expect(controls.nowPlaying?.subtitle, 'Bismillah');
      audio.finish();
      await playback;
      expect(model.isPlayingBismillah, isFalse);
      expect(quran.savedLastRead, isEmpty);
      expect(model.ayahs.single.id, 8);
      expect(model.ayahs.single.ayahNumber, 1);
    },
  );

  test(
    'full playback includes the opening, then highlights actual verse one',
    () async {
      await model.openSurah(readerSurah(2));
      final playback = model.playFullSurah();
      await Future<void>.delayed(Duration.zero);
      expect(audio.queue.map((a) => a.id), [1, 8]);
      expect(audio.stopCalls, 0);
      expect(audio.queue.map((a) => a.ayahNumber), [0, 1]);
      expect(model.isPlayingBismillah, isTrue);
      expect(model.isAyahPlaying(1), isFalse);
      audio.currentAyah.add(1);
      expect(model.isPlayingBismillah, isFalse);
      expect(model.isAyahPlaying(1), isTrue);
      audio.finish();
      await playback;
      expect(model.isPlayingFullSurah, isFalse);
      expect(model.playingAyahNumber, isNull);
    },
  );

  test('Fatiha and Tawbah never gain an extra opening audio track', () async {
    for (final surah in [1, 9]) {
      await model.openSurah(readerSurah(surah));
      expect(model.openingBismillah, isNull);
      await model.playBismillah();
      expect(audio.tracks, isEmpty);
      final playback = model.playFullSurah();
      await Future<void>.delayed(Duration.zero);
      expect(audio.queue, hasLength(1));
      expect(audio.queue.first.ayahNumber, 1);
      audio.finish();
      await playback;
    }
  });

  test(
    'playing actual verse one stops Bismillah and retains its own audio',
    () async {
      await model.openSurah(readerSurah(2));
      final openingPlayback = model.playBismillah();
      await Future<void>.delayed(Duration.zero);
      final versePlayback = model.playAyah(model.ayahs.first);
      await Future<void>.delayed(Duration.zero);
      await openingPlayback;
      expect(audio.tracks.map((a) => a.id), [1, 8]);
      expect(model.isPlayingBismillah, isFalse);
      expect(model.isAyahPlaying(1), isTrue);
      audio.finish();
      await versePlayback;
      expect(quran.savedLastRead, [(2, 1)]);
    },
  );

  test(
    'an interrupted full queue cannot clear the replacement highlight',
    () async {
      await model.openSurah(readerSurah(2));
      final fullPlayback = model.playFullSurah();
      await Future<void>.delayed(Duration.zero);
      final openingPlayback = model.playBismillah();
      await Future<void>.delayed(Duration.zero);
      await fullPlayback;
      expect(model.isPlayingFullSurah, isFalse);
      expect(model.isPlayingBismillah, isTrue);
      await model.stopPlayback();
      await openingPlayback;
      expect(model.isPlayingBismillah, isFalse);
    },
  );

  test('opening audio errors reset controls and allow retry', () async {
    await model.openSurah(readerSurah(2));
    audio.failPlayback = true;
    await expectLater(model.playBismillah(), throwsStateError);
    expect(model.isPlayingBismillah, isFalse);
    expect(model.playingAyahNumber, isNull);
    audio.failPlayback = false;
    final playback = model.playBismillah();
    await Future<void>.delayed(Duration.zero);
    expect(model.isPlayingBismillah, isTrue);
    await model.stopPlayback();
    await playback;
  });

  test(
    'switching surahs cancels the opening and keeps verse bookmarks',
    () async {
      await model.openSurah(readerSurah(2));
      await model.toggleAyahBookmark(model.ayahs.first);
      expect(quran.bookmarks, {1});
      final playback = model.playBismillah();
      await Future<void>.delayed(Duration.zero);
      await model.openSurah(readerSurah(9));
      await playback;
      expect(model.isPlayingBismillah, isFalse);
      expect(model.openingBismillah, isNull);
      expect(quran.savedLastRead, isEmpty);
    },
  );

  test('a slow stop cannot reopen a surah after a newer selection', () async {
    await model.openSurah(readerSurah(2));
    final playback = model.playBismillah();
    await Future<void>.delayed(Duration.zero);
    audio.stopGate = Completer<void>();
    final firstSelection = model.openSurah(readerSurah(9));
    await model.openSurah(readerSurah(114));
    audio.stopGate!.complete();
    await firstSelection;
    await playback;
    expect(model.surah!.id, 114);
    expect(model.ayahs.single.surahId, 114);
    expect(model.openingBismillah!.surahId, 114);
  });
}

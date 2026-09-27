import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:quran_for_all/data/models/surah_opening_model.dart';
import 'package:quran_for_all/services/audio_service.dart';

import '../support/quran_reader_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory cache;
  late _AudioPlayer player;
  late AudioService service;

  setUp(() async {
    cache = await Directory.systemTemp.createTemp('quran_audio_test_');
    player = _AudioPlayer();
  });
  tearDown(() async {
    await service.dispose();
    await cache.delete(recursive: true);
  });

  void createService(http.Client client) {
    service = AudioService(
      httpClient: client,
      audioPlayer: player,
      audioCacheDirectory: () async => cache,
    );
  }

  test('a completed download cannot restart audio after stop', () async {
    final response = Completer<http.Response>();
    final requested = Completer<void>();
    createService(
      MockClient((_) {
        requested.complete();
        return response.future;
      }),
    );
    final playback = service.playAyah(readerAyah(id: 1));
    await requested.future;
    await service.stop();
    response.complete(http.Response('audio', 200));
    await playback;
    expect(player.playedFiles, isEmpty);
    expect(service.isPlaying, isFalse);
  });

  test(
    'a replaced download cannot start or clear the newer playback',
    () async {
      final oldResponse = Completer<http.Response>();
      final oldRequested = Completer<void>();
      createService(
        MockClient((request) {
          if (request.url.path.endsWith('/1.mp3')) {
            oldRequested.complete();
            return oldResponse.future;
          }
          return Future.value(http.Response('audio', 200));
        }),
      );
      final oldPlayback = service.playAyah(readerAyah(id: 1));
      await oldRequested.future;
      final newPlayback = service.playAyah(readerAyah());
      await player.firstPlay.future;
      oldResponse.complete(http.Response('audio', 200));
      await oldPlayback;
      expect(player.playedFiles.single, endsWith('/8.mp3'));
      expect(service.isPlaying, isTrue);
      player.completeTrack();
      await newPlayback;
      expect(service.isPlaying, isFalse);
    },
  );

  test(
    'opening plays before verse one and reuses Fatiha offline audio',
    () async {
      await File('${cache.path}/1.mp3').writeAsString('cached Bismillah');
      final requestedUrls = <String>[];
      createService(
        MockClient((request) async {
          requestedUrls.add(request.url.toString());
          return http.Response('audio', 200);
        }),
      );
      final playedNumbers = <int>[];
      final playingStates = <bool>[];
      final subscription = service.currentAyahNumberStream.listen(
        playedNumbers.add,
      );
      final playingSubscription = service.isPlayingStream.listen(
        playingStates.add,
      );
      addTearDown(subscription.cancel);
      addTearDown(playingSubscription.cancel);
      player.completeImmediately = true;
      final opening = SurahOpeningModel(
        source: readerAyah(id: 1, surahId: 1, arabic: bismillahArabic),
        surahId: 2,
      );
      await service.playSurah([opening.playbackEntry, readerAyah()]);
      await Future<void>.delayed(Duration.zero);
      expect(player.playedFiles.map((path) => path.split('/').last), [
        '1.mp3',
        '8.mp3',
      ]);
      expect(playedNumbers, [0, 1]);
      expect(playingStates, [true, false]);
      expect(requestedUrls, [readerAyah().audioUrl]);
      expect(service.isPlaying, isFalse);
    },
  );

  test(
    'stopping a queue during its opening never advances to verse one',
    () async {
      createService(MockClient((_) async => http.Response('audio', 200)));
      final playback = service.playSurah([
        readerAyah(id: 1, number: 0),
        readerAyah(),
      ]);
      await player.firstPlay.future;
      await service.stop();
      await playback;
      expect(player.playedFiles, hasLength(1));
      expect(service.isPlaying, isFalse);
    },
  );

  test(
    'player errors clear playback state so the opening can be retried',
    () async {
      createService(MockClient((_) async => http.Response('audio', 200)));
      player.failPlayback = true;
      await expectLater(service.playAyah(readerAyah()), throwsStateError);
      expect(service.isPlaying, isFalse);
      player.failPlayback = false;
      player.completeImmediately = true;
      await service.playAyah(readerAyah());
      expect(service.isPlaying, isFalse);
    },
  );
}

class _AudioPlayer implements AudioPlayer {
  final states = StreamController<PlayerState>.broadcast(sync: true);
  final completions = StreamController<void>.broadcast(sync: true);
  final playedFiles = <String>[];
  final firstPlay = Completer<void>();
  bool completeImmediately = false;
  bool failPlayback = false;

  @override
  Stream<PlayerState> get onPlayerStateChanged => states.stream;
  @override
  Stream<void> get onPlayerComplete => completions.stream;

  @override
  Future<void> play(
    Source source, {
    double? volume,
    double? balance,
    AudioContext? ctx,
    Duration? position,
    PlayerMode? mode,
  }) async {
    if (failPlayback) throw StateError('Player failed');
    playedFiles.add((source as DeviceFileSource).path);
    states.add(PlayerState.playing);
    if (!firstPlay.isCompleted) firstPlay.complete();
    if (completeImmediately) {
      Future<void>.delayed(Duration.zero, completeTrack);
    }
  }

  void completeTrack() {
    states.add(PlayerState.completed);
    completions.add(null);
  }

  @override
  Future<void> stop() async => states.add(PlayerState.stopped);

  @override
  Future<void> dispose() async {
    await states.close();
    await completions.close();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

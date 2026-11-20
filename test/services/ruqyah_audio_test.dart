import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:quran_for_all/services/ruqyah/ruqyah_audio_cache.dart';
import 'package:quran_for_all/presentation/viewmodels/ruqyah/ruqyah_audio_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('ruqyah_audio_test_');
  });
  tearDown(() async {
    await directory.delete(recursive: true);
  });
  List<int> mp3() => [0x49, 0x44, 0x33, ...List.filled(200, 0)];

  test(
    'audio is fetched only after download, with exact passage IDs and reusable files',
    () async {
      final requests = <String>[];
      final cache = RuqyahAudioCache(
        directory: () async => directory,
        client: MockClient((request) async {
          requests.add(request.url.path);
          return http.Response.bytes(
            mp3(),
            200,
            headers: {'content-type': 'audio/mpeg'},
          );
        }),
      );
      addTearDown(cache.dispose);
      expect(await cache.isDownloaded([292, 293]), isFalse);
      expect(requests, isEmpty);
      final progress = <double>[];
      await cache.download([292, 293], progress.add);
      expect(requests, [
        '/quran/audio/128/ar.alafasy/292.mp3',
        '/quran/audio/128/ar.alafasy/293.mp3',
      ]);
      expect(await cache.isDownloaded([292, 293]), isTrue);
      expect(progress.last, 1);
      await cache.download([292, 293], (_) {});
      expect(requests, hasLength(2));
    },
  );

  test(
    'HTML and incomplete audio never become usable cached recordings',
    () async {
      final cache = RuqyahAudioCache(
        directory: () async => directory,
        client: MockClient(
          (_) async => http.Response('<html>error</html>', 200),
        ),
      );
      addTearDown(cache.dispose);
      await expectLater(cache.download([262], (_) {}), throwsFormatException);
      expect(await cache.localPath(262), isNull);
      expect(await directory.list().toList(), isEmpty);
    },
  );

  test(
    'passage playback advances verses, repeats only when selected, and can replay',
    () async {
      final player = _Player();
      var stoppedShared = 0;
      final controller = RuqyahAudioController(
        cache: RuqyahAudioCache(directory: () async => directory),
        playerFactory: () => player,
        configureSession: () async {},
        beforePlay: () async {
          stoppedShared++;
        },
      );
      addTearDown(controller.dispose);
      await controller.select([6222, 6223]);
      expect(player.sources, isEmpty);
      await controller.toggle();
      expect((player.sources.single as UrlSource).url, endsWith('/6222.mp3'));
      player.complete();
      await _until(() => player.sources.length == 2 && controller.playing);
      expect((player.sources.last as UrlSource).url, endsWith('/6223.mp3'));
      player.complete();
      expect(controller.playing, isFalse);
      await controller.toggle();
      expect((player.sources.last as UrlSource).url, endsWith('/6222.mp3'));
      expect(stoppedShared, 3);
      controller.toggleRepeat();
      player.complete();
      await _until(() => player.sources.length == 4 && controller.playing);
      player.complete();
      await _until(() => player.sources.length == 5 && controller.playing);
      expect((player.sources.last as UrlSource).url, endsWith('/6222.mp3'));
    },
  );

  test('leaving during pending setup cannot start a stale recording', () async {
    final gate = Completer<void>();
    final entered = Completer<void>();
    final player = _Player();
    final controller = RuqyahAudioController(
      cache: RuqyahAudioCache(directory: () async => directory),
      playerFactory: () => player,
      configureSession: () async {},
      beforePlay: () {
        entered.complete();
        return gate.future;
      },
    );
    addTearDown(controller.dispose);
    await controller.select([262]);
    final started = controller.toggle();
    await entered.future;
    await controller.select([292, 293]);
    gate.complete();
    await started;
    expect(player.sources, isEmpty);
    expect(controller.playing, isFalse);
  });
}

Future<void> _until(bool Function() ready) async {
  for (var i = 0; i < 1000 && !ready(); i++) {
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }
  expect(ready(), isTrue);
}

class _Player implements AudioPlayer {
  final sources = <Source>[];
  final _complete = StreamController<void>.broadcast(sync: true);
  @override
  Stream<void> get onPlayerComplete => _complete.stream;
  @override
  Stream<PlayerState> get onPlayerStateChanged => const Stream.empty();
  @override
  Stream<Duration> get onPositionChanged => const Stream.empty();
  @override
  Stream<Duration> get onDurationChanged => const Stream.empty();
  @override
  Future<void> play(
    Source source, {
    double? volume,
    double? balance,
    AudioContext? ctx,
    Duration? position,
    PlayerMode? mode,
  }) async {
    sources.add(source);
  }

  void complete() => _complete.add(null);
  @override
  Future<void> stop() async {}
  @override
  Future<void> dispose() async {
    await _complete.close();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/data/models/dhikr_reminders/dhikr_reminder_sound.dart';
import 'package:quran_for_all/services/dhikr_reminders/dhikr_sound_preview.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'player is lazy; play, stop and completion keep preview controls in sync',
    () async {
      final player = _Player();
      var created = 0;
      final preview = DhikrSoundPreview(
        createPlayer: () {
          created++;
          return player;
        },
      );
      expect(created, 0);
      await preview.toggle(DhikrReminderSound.quran);
      expect(created, 1);
      expect(preview.activeSound, DhikrReminderSound.quran);
      expect(preview.loading, false);
      player.completed.add(null);
      expect(preview.activeSound, isNull);
      await preview.toggle(DhikrReminderSound.ramadan);
      await preview.toggle(DhikrReminderSound.ramadan);
      expect(preview.activeSound, isNull);
      expect(player.events.last, 'stop');
      preview.dispose();
      await Future<void>.delayed(Duration.zero);
      expect(player.disposed, true);
    },
  );

  test(
    'rapid changes serialize native commands and never play the stale selection last',
    () async {
      final player = _Player()..gate = Completer<void>();
      final preview = DhikrSoundPreview(createPlayer: () => player);
      final first = preview.toggle(DhikrReminderSound.arRahman);
      await Future<void>.delayed(Duration.zero);
      expect(
        player.events.last,
        'play:audio/reminders/aarahman_notification.wav',
      );
      final last = preview.toggle(DhikrReminderSound.quran);
      player.gate!.complete();
      await first;
      await last;
      expect(player.events.where((event) => event.startsWith('play:')), [
        'play:audio/reminders/aarahman_notification.wav',
        'play:audio/reminders/quran_notification.wav',
      ]);
      expect(player.events[player.events.length - 2], 'stop');
      expect(preview.activeSound, DhikrReminderSound.quran);
      preview.dispose();
      await Future<void>.delayed(Duration.zero);
    },
  );

  test('failure is retryable and app suspension stops playback', () async {
    final player = _Player()..fail = true;
    final preview = DhikrSoundPreview(createPlayer: () => player);
    await preview.toggle(DhikrReminderSound.allahHu);
    expect(preview.failed, true);
    expect(preview.activeSound, isNull);
    player.fail = false;
    await preview.toggle(DhikrReminderSound.allahHu);
    expect(preview.failed, false);
    preview.didChangeAppLifecycleState(AppLifecycleState.paused);
    await Future<void>.delayed(Duration.zero);
    expect(preview.activeSound, isNull);
    expect(player.events.last, 'stop');
    preview.dispose();
    await Future<void>.delayed(Duration.zero);
  });

  test(
    'closing during a pending play disposes the player after pending commands finish',
    () async {
      final player = _Player()..gate = Completer<void>();
      final preview = DhikrSoundPreview(createPlayer: () => player);
      final playing = preview.toggle(DhikrReminderSound.rahman);
      await Future<void>.delayed(Duration.zero);
      preview.dispose();
      player.gate!.complete();
      await playing;
      await Future<void>.delayed(Duration.zero);
      expect(player.disposed, true);
      final count = player.events.length;
      await preview.toggle(DhikrReminderSound.quran);
      expect(player.events, hasLength(count));
    },
  );
}

class _Player implements AudioPlayer {
  final completed = StreamController<void>.broadcast(sync: true);
  final states = StreamController<PlayerState>.broadcast(sync: true);
  final events = <String>[];
  Completer<void>? gate;
  bool fail = false, disposed = false;
  @override
  Stream<void> get onPlayerComplete => completed.stream;
  @override
  Stream<PlayerState> get onPlayerStateChanged => states.stream;
  @override
  Future<void> setAudioContext(AudioContext context) async {
    events.add('context');
  }

  @override
  Future<void> setReleaseMode(ReleaseMode mode) async {
    events.add('release');
  }

  @override
  Future<void> stop() async {
    events.add('stop');
  }

  @override
  Future<void> play(
    Source source, {
    double? volume,
    double? balance,
    AudioContext? ctx,
    Duration? position,
    PlayerMode? mode,
  }) async {
    events.add('play:${(source as AssetSource).path}');
    if (fail) throw StateError('Cannot play');
    await gate?.future;
  }

  @override
  Future<void> dispose() async {
    disposed = true;
    await completed.close();
    await states.close();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

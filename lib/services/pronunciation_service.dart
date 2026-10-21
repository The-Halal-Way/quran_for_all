import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../core/quran/arabic_pronunciation_text.dart';
import '../core/quran/recorded_pronunciation_catalog.dart';
import 'pronunciation_voice_selector.dart';
import 'recorded_pronunciation_player.dart';

export 'pronunciation_voice_selector.dart'
    show PronunciationException, PronunciationFailure;

/// Prefers offline recordings. Device speech is lazy and only used for exercises
/// that do not yet have a matching recording.
class PronunciationService {
  final _recordings = RecordedPronunciationPlayer();
  FlutterTts? _tts;
  Future<void>? _initialization;
  Map<String, String>? _voice;
  int? _ttsRequest;
  bool _disposed = false;
  int _request = 0;
  bool _isSpeaking = false;
  String? _currentText;

  bool get isSpeaking => _isSpeaking;
  String? get currentText => _currentText;
  bool get canInstallVoice =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  final _speakingController = StreamController<bool>.broadcast();
  Stream<bool> get speakingStream => _speakingController.stream;

  Future<void> _initialize() async {
    final tts = _tts ??= FlutterTts();
    tts.setStartHandler(() {
      if (_ttsRequest == _request) _setSpeaking(true);
    });
    // The awaited result below owns completion/cancellation. Old callbacks
    // must not clear the state of a newer pronunciation request.
    tts.setCompletionHandler(() {});
    tts.setCancelHandler(() {});
    tts.setErrorHandler((message) {
      debugPrint('PronunciationService: $message');
    });

    _voice = await selectArabicPronunciationVoice(tts);
    if (_disposed) return;
    await tts.setSpeechRate(.4);
    await tts.setVolume(1);
    await tts.setPitch(1);
    await tts.awaitSpeakCompletion(true);
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      await tts.setSharedInstance(true);
      await tts.setIosAudioCategory(IosTextToSpeechAudioCategory.playback, []);
    }
    debugPrint(
      'PronunciationService: Arabic voice ${_voice!['name']} (${_voice!['locale']})',
    );
  }

  /// Raw text remains the UI identity regardless of the audio source.
  Future<void> speak(String text) async {
    if (_disposed) return;
    if (_currentText == text) {
      await stop();
      return;
    }
    final request = ++_request;
    _clearSpeech();
    _currentText = text;
    final assets = RecordedPronunciationCatalog.assetsFor(text);
    try {
      await _stopPlayback();
      if (_disposed || request != _request) return;
      if (assets != null) {
        await _recordings.play(
          assets,
          onStarted: () {
            if (!_disposed && request == _request) _setSpeaking(true);
          },
        );
      } else {
        await _speakWithTts(text, request);
      }
    } catch (error) {
      if (_disposed || request != _request) return;
      if (assets == null) _initialization = null;
      debugPrint('PronunciationService: pronunciation failed: $error');
      try {
        await _stopPlayback();
      } catch (_) {
        // The original error is the one the pronunciation button presents.
      }
      if (_disposed || request != _request) return;
      if (error is PronunciationException) rethrow;
      throw const PronunciationException(PronunciationFailure.playbackFailed);
    } finally {
      if (!_disposed && request == _request) _clearSpeech();
    }
  }

  Future<void> _speakWithTts(String text, int request) async {
    await (_initialization ??= _initialize().timeout(
      const Duration(seconds: 20),
    ));
    if (_disposed || request != _request) return;
    final tts = _tts!;
    // Reapply the verified voice in case the platform engine reconnected.
    if (await tts.setVoice(_voice!) != 1) {
      throw const PronunciationException(
        PronunciationFailure.arabicVoiceUnavailable,
      );
    }
    if (_disposed || request != _request) return;
    final spoken = ArabicPronunciationText.spokenForm(text);
    if (spoken.isEmpty) {
      throw const PronunciationException(PronunciationFailure.playbackFailed);
    }
    _ttsRequest = request;
    final result = await tts
        .speak(spoken, focus: true)
        .timeout(const Duration(seconds: 45));
    if (_disposed || request != _request) return;
    if (result != 1) {
      throw const PronunciationException(PronunciationFailure.playbackFailed);
    }
  }

  Future<void> _stopPlayback() async {
    _ttsRequest = null;
    await Future.wait([
      _recordings.stop(),
      if (_tts case final tts?) tts.stop(),
    ]);
  }

  Future<bool> installArabicVoice() async {
    if (!canInstallVoice || _disposed) return false;
    try {
      _initialization = null;
      return await (_tts ??= FlutterTts()).installVoiceData();
    } catch (_) {
      return false;
    }
  }

  void _setSpeaking(bool speaking) {
    if (_disposed) return;
    _isSpeaking = speaking;
    if (!_speakingController.isClosed) _speakingController.add(speaking);
  }

  void _clearSpeech() {
    if (_disposed) return;
    _currentText = null;
    _setSpeaking(false);
  }

  Future<void> stop() async {
    ++_request;
    _clearSpeech();
    try {
      await _stopPlayback();
    } catch (_) {
      // Stopping remains safe when the speech engine is unavailable.
    }
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    ++_request;
    try {
      await _stopPlayback();
    } finally {
      try {
        await _recordings.dispose();
      } finally {
        await _speakingController.close();
      }
    }
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Lightweight TTS wrapper for Arabic letter and word pronunciation.
///
/// Uses the device's built-in Arabic TTS engine (available on both iOS and
/// Android). Designed for short, single-shot utterances — not for long-form
/// recitation.
class PronunciationService {
  PronunciationService() {
    _init();
  }

  final FlutterTts _tts = FlutterTts();

  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  /// Currently speaking text (used to highlight the active button).
  String? _currentText;
  String? get currentText => _currentText;

  final StreamController<bool> _speakingController =
      StreamController<bool>.broadcast();
  Stream<bool> get speakingStream => _speakingController.stream;

  Future<void> _init() async {
    try {
      await _tts.setLanguage('ar');
      await _tts.setSpeechRate(0.4); // slower for clarity
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);

      _tts.setStartHandler(() {
        _isSpeaking = true;
        if (!_speakingController.isClosed) {
          _speakingController.add(true);
        }
      });

      _tts.setCompletionHandler(() {
        _isSpeaking = false;
        _currentText = null;
        if (!_speakingController.isClosed) {
          _speakingController.add(false);
        }
      });

      _tts.setCancelHandler(() {
        _isSpeaking = false;
        _currentText = null;
        if (!_speakingController.isClosed) {
          _speakingController.add(false);
        }
      });

      _tts.setErrorHandler((message) {
        debugPrint('PronunciationService TTS error: $message');
        _isSpeaking = false;
        _currentText = null;
        if (!_speakingController.isClosed) {
          _speakingController.add(false);
        }
      });
    } catch (e) {
      debugPrint('PronunciationService: failed to initialise TTS - $e');
    }
  }

  /// Speak [text] using the Arabic TTS voice.
  ///
  /// If the same [text] is already being spoken, stops playback instead
  /// (toggle behaviour). If different text is playing, stops it and starts
  /// the new one.
  Future<void> speak(String text) async {
    if (_isSpeaking && _currentText == text) {
      await stop();
      return;
    }

    if (_isSpeaking) {
      await _tts.stop();
    }

    _currentText = text;
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
    _isSpeaking = false;
    _currentText = null;
    if (!_speakingController.isClosed) {
      _speakingController.add(false);
    }
  }

  Future<void> dispose() async {
    await _tts.stop();
    await _speakingController.close();
  }
}

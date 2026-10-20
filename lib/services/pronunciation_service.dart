import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Lightweight TTS wrapper for Arabic letter and word pronunciation.
///
/// Uses the device's built-in Arabic TTS engine (available on both iOS and
/// Android). Designed for short, single-shot utterances — not for long-form
/// recitation.
class PronunciationService {
  FlutterTts? _tts;
  Future<bool>? _initialization;
  bool _disposed = false;
  int _request = 0;

  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  /// Currently speaking text (used to highlight the active button).
  String? _currentText;
  String? get currentText => _currentText;

  final StreamController<bool> _speakingController =
      StreamController<bool>.broadcast();
  Stream<bool> get speakingStream => _speakingController.stream;

  Future<bool> _init() async {
    final tts = _tts ??= FlutterTts();
    try {
      tts.setStartHandler(() {
        if (_disposed) return;
        _isSpeaking = true;
        if (!_speakingController.isClosed) {
          _speakingController.add(true);
        }
      });

      tts.setCompletionHandler(() {
        _isSpeaking = false;
        _currentText = null;
        if (!_speakingController.isClosed) {
          _speakingController.add(false);
        }
      });

      tts.setCancelHandler(() {
        _isSpeaking = false;
        _currentText = null;
        if (!_speakingController.isClosed) {
          _speakingController.add(false);
        }
      });

      tts.setErrorHandler((message) {
        debugPrint('PronunciationService TTS error: $message');
        _isSpeaking = false;
        _currentText = null;
        if (!_speakingController.isClosed) {
          _speakingController.add(false);
        }
      });
      await tts.setLanguage('ar');
      if (_disposed) return false;
      await tts.setSpeechRate(0.4); // slower for clarity
      if (_disposed) return false;
      await tts.setVolume(1.0);
      if (_disposed) return false;
      await tts.setPitch(1.0);
      return !_disposed;
    } catch (e) {
      debugPrint('PronunciationService: failed to initialise TTS - $e');
      return false;
    }
  }

  /// Speak [text] using the Arabic TTS voice.
  ///
  /// If the same [text] is already being spoken, stops playback instead
  /// (toggle behaviour). If different text is playing, stops it and starts
  /// the new one.
  Future<void> speak(String text) async {
    if (_disposed) return;
    final request = ++_request;
    // Reading the speaking stream (e.g. building lesson buttons) stays cheap.
    // Only an actual pronunciation request initializes the native engine.
    final ready = await (_initialization ??= _init());
    if (_disposed || request != _request) return;
    if (!ready) {
      _initialization = null;
      return;
    }
    final tts = _tts!;
    if (_isSpeaking && _currentText == text) {
      await stop();
      return;
    }

    if (_isSpeaking) {
      await tts.stop();
    }

    if (_disposed || request != _request) return;
    _currentText = text;
    await tts.speak(text);
  }

  Future<void> stop() async {
    _request++;
    await _tts?.stop();
    _isSpeaking = false;
    _currentText = null;
    if (!_speakingController.isClosed) {
      _speakingController.add(false);
    }
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _request++;
    await _tts?.stop();
    await _speakingController.close();
  }
}

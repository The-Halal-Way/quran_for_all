import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import '../../core/enums/playback_source.dart';
import '../../domain/repositories/audio_repository.dart';

/// Holds the display information for the currently playing audio item.
class NowPlayingInfo {
  const NowPlayingInfo({
    required this.title,
    this.subtitle,
    required this.source,
  });

  final String title;
  final String? subtitle;
  final PlaybackSource source;
}

/// Manages global audio playback state for the mini-player overlay.
///
/// Responsibilities:
/// - Reflects whether audio is currently playing (driven by [AudioRepository]).
/// - Knows which page *started* the audio ([PlaybackSource] source).
/// - Knows which page is currently *active / visible* in the navigator.
/// - Computes [showMiniPlayer]: show the bar whenever audio is active.
class AudioControlViewModel extends ChangeNotifier {
  AudioControlViewModel({required AudioRepository audioRepository})
    : _audioRepository = audioRepository {
    _subscription = _audioRepository.isPlayingStream.listen(_onPlayingChanged);
    _pausedSubscription = _audioRepository.isPausedStream.listen((paused) {
      _isPaused = paused;
      notifyListeners();
    });
    _positionSubscription = _audioRepository.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });
    _durationSubscription = _audioRepository.durationStream.listen((dur) {
      _duration = dur;
      notifyListeners();
    });
  }

  final AudioRepository _audioRepository;
  late final StreamSubscription<bool> _subscription;
  late final StreamSubscription<bool> _pausedSubscription;
  late final StreamSubscription<Duration> _positionSubscription;
  late final StreamSubscription<Duration> _durationSubscription;

  NowPlayingInfo? _nowPlaying;
  PlaybackSource _activePage = PlaybackSource.none;
  bool _isPlaying = false;
  bool _isPaused = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  // ── Public state ──────────────────────────────────────────────────────────

  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;

  NowPlayingInfo? get nowPlaying => _nowPlaying;

  Duration get position => _position;
  Duration get duration => _duration;

  /// Progress value from 0.0 to 1.0 for the playback progress indicator.
  double get progress => _duration.inMilliseconds > 0
      ? (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0)
      : 0.0;

  /// True when a mini-player should be shown at the bottom of the app.
  ///
  /// Condition: audio is active (playing OR paused) and there is now-playing
  /// context.
  bool get showMiniPlayer => (_isPlaying || _isPaused) && _nowPlaying != null;

  // ── Called by viewmodels when they initiate playback ─────────────────────

  void setPlaybackContext({
    required PlaybackSource source,
    required String title,
    String? subtitle,
  }) {
    _nowPlaying = NowPlayingInfo(
      title: title,
      subtitle: subtitle,
      source: source,
    );
    notifyListeners();
  }

  // ── Called by views (StatefulWidget) to register which page is visible ───

  /// Mark [page] as the currently visible / active page.
  void setActivePage(PlaybackSource page) {
    if (_activePage == page) return;
    _activePage = page;
    notifyListeners();
  }

  /// Called from a page's [dispose] to clear its active registration.
  /// Notification is deferred to the next frame so it is safe to call during
  /// widget disposal (avoids "setState called when tree was locked").
  void clearActivePage(PlaybackSource page) {
    if (_activePage != page) return;
    _activePage = PlaybackSource.none;
    SchedulerBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  // ── Audio control ─────────────────────────────────────────────────────────

  Future<void> togglePlayPause() {
    if (_isPaused) return _audioRepository.resume();
    return _audioRepository.pause();
  }

  Future<void> stop() => _audioRepository.stop();

  // ── Internal ──────────────────────────────────────────────────────────────

  void _onPlayingChanged(bool isPlaying) {
    if (_isPlaying == isPlaying) return;
    _isPlaying = isPlaying;
    if (!isPlaying) {
      // Clear context so mini-player disappears when playback ends naturally.
      _nowPlaying = null;
      _isPaused = false;
      _position = Duration.zero;
      _duration = Duration.zero;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _pausedSubscription.cancel();
    _positionSubscription.cancel();
    _durationSubscription.cancel();
    super.dispose();
  }
}

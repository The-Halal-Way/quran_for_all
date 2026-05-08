import 'dart:async';

import 'package:flutter/foundation.dart';

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
/// - Computes [showMiniPlayer]: show the bar only when playing and the user
///   has navigated away from the source page.
class AudioControlViewModel extends ChangeNotifier {
  AudioControlViewModel({required AudioRepository audioRepository})
    : _audioRepository = audioRepository {
    _subscription = _audioRepository.isPlayingStream.listen(_onPlayingChanged);
  }

  final AudioRepository _audioRepository;
  late final StreamSubscription<bool> _subscription;

  NowPlayingInfo? _nowPlaying;
  PlaybackSource _activePage = PlaybackSource.none;
  bool _isPlaying = false;

  // ── Public state ──────────────────────────────────────────────────────────

  bool get isPlaying => _isPlaying;

  NowPlayingInfo? get nowPlaying => _nowPlaying;

  /// True when a mini-player should be shown at the top of the app.
  ///
  /// Condition: audio is playing AND the user is NOT on the page that started it.
  bool get showMiniPlayer =>
      _isPlaying &&
      _nowPlaying != null &&
      _activePage != _nowPlaying!.source;

  // ── Called by viewmodels when they initiate playback ─────────────────────

  void setPlaybackContext({
    required PlaybackSource source,
    required String title,
    String? subtitle,
  }) {
    _nowPlaying = NowPlayingInfo(title: title, subtitle: subtitle, source: source);
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
  void clearActivePage(PlaybackSource page) {
    if (_activePage != page) return;
    _activePage = PlaybackSource.none;
    notifyListeners();
  }

  // ── Audio control ─────────────────────────────────────────────────────────

  Future<void> stop() => _audioRepository.stop();

  // ── Internal ──────────────────────────────────────────────────────────────

  void _onPlayingChanged(bool isPlaying) {
    if (_isPlaying == isPlaying) return;
    _isPlaying = isPlaying;
    if (!isPlaying) {
      // Clear context so mini-player disappears when playback ends naturally.
      _nowPlaying = null;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

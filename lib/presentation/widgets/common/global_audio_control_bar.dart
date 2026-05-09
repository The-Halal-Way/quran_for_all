import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../viewmodels/audio_control_viewmodel.dart';

/// Global audio mini-player that overlays the bottom of the app whenever
/// audio is active (playing or paused) and the user is not on the source page.
///
/// Layout:
///   [thin progress bar]
///   [music icon]  [title / subtitle]  [play/pause]  [stop]
class GlobalAudioControlBar extends StatelessWidget {
  const GlobalAudioControlBar({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AudioControlViewModel>();
    if (!vm.showMiniPlayer) return const SizedBox.shrink();

    final nowPlaying = vm.nowPlaying!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final onPrimary = colorScheme.onPrimary;

    return Material(
      color: colorScheme.primary,
      elevation: 12,
      shadowColor: Colors.black45,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Playback progress bar ────────────────────────────────────
          LinearProgressIndicator(
            value: vm.progress,
            minHeight: 3,
            backgroundColor: onPrimary.withValues(alpha: 0.25),
            valueColor: AlwaysStoppedAnimation<Color>(onPrimary),
          ),

          // ── Content row ──────────────────────────────────────────────
          SafeArea(
            top: false,
            child: SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    // ── Pulsing / paused icon ──────────────────────────
                    vm.isPaused
                        ? Icon(Icons.music_note_rounded, color: onPrimary, size: 22)
                        : _PulsingIcon(color: onPrimary),
                    const SizedBox(width: AppSpacing.sm + 2),

                    // ── Title + subtitle ───────────────────────────────
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nowPlaying.title,
                            style: textTheme.bodyMedium?.copyWith(
                              color: onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (nowPlaying.subtitle != null) ...[
                            const SizedBox(height: 1),
                            Text(
                              nowPlaying.subtitle!,
                              style: textTheme.labelSmall?.copyWith(
                                color: onPrimary.withValues(alpha: 0.75),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),

                    // ── Play / Pause button ────────────────────────────
                    IconButton(
                      icon: Icon(
                        vm.isPaused
                            ? Icons.play_circle_rounded
                            : Icons.pause_circle_rounded,
                        color: onPrimary,
                        size: 28,
                      ),
                      onPressed: () =>
                          context.read<AudioControlViewModel>().togglePlayPause(),
                    ),

                    // ── Stop button ────────────────────────────────────
                    IconButton(
                      icon: Icon(
                        Icons.stop_circle_rounded,
                        color: onPrimary,
                        size: 28,
                      ),
                      onPressed: () =>
                          context.read<AudioControlViewModel>().stop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A simple pulsing music note icon that subtly animates to indicate live playback.
class _PulsingIcon extends StatefulWidget {
  const _PulsingIcon({required this.color});

  final Color color;

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Icon(Icons.music_note_rounded, color: widget.color, size: 22),
    );
  }
}

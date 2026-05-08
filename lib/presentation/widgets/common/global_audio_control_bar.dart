import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/audio_control_viewmodel.dart';

/// Compact global audio mini-player shown at the top of the app whenever
/// audio is playing and the user is not on the source page.
///
/// Layout (inside SafeArea):
///   [music icon]  [title / subtitle]  [stop button]
class GlobalAudioControlBar extends StatelessWidget {
  const GlobalAudioControlBar({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AudioControlViewModel>();
    if (!vm.showMiniPlayer) return const SizedBox.shrink();

    final nowPlaying = vm.nowPlaying!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.primary,
      elevation: 4,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 52,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                // ── Pulsing music icon ───────────────────────────────────
                _PulsingIcon(color: colorScheme.onPrimary),
                const SizedBox(width: 10),

                // ── Title + subtitle ─────────────────────────────────────
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nowPlaying.title,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimary,
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
                            color: colorScheme.onPrimary.withValues(alpha: 0.75),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // ── Stop button ──────────────────────────────────────────
                IconButton(
                  icon: Icon(
                    Icons.stop_circle_rounded,
                    color: colorScheme.onPrimary,
                    size: 28,
                  ),
                  tooltip: 'Stop playback',
                  onPressed: () => context.read<AudioControlViewModel>().stop(),
                ),
              ],
            ),
          ),
        ),
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

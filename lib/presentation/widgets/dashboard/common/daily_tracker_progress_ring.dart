import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

/// Shared by the dashboard preview and the full tracker. Painted without assets.
class DailyTrackerProgressRing extends StatelessWidget {
  const DailyTrackerProgressRing({
    super.key,
    required this.completed,
    required this.total,
    this.size = 82,
    this.onDark = false,
  });
  final int completed;
  final int total;
  final double size;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : (completed / total).clamp(0.0, 1.0);
    final colors = Theme.of(context).colorScheme;
    final label = NumberFormat.percentPattern(
      context.l10n.localeName,
    ).format(progress);
    return Semantics(
      label: context.l10n.dailyTrackerProgressLabel(completed, total),
      child: ExcludeSemantics(
        child: SizedBox.square(
          dimension: size,
          child: CustomPaint(
            painter: _ProgressRingPainter(
              progress: progress,
              track: onDark
                  ? Colors.white12
                  : colors.onSurface.withValues(alpha: 0.08),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppTheme.text(context).titleMedium.copyWith(
                      color: onDark ? Colors.white : colors.onSurface,
                      fontWeight: AppTheme.weightExtraBold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({required this.progress, required this.track});
  final double progress;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(5);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi,
      false,
      paint..color = track,
    );
    if (progress == 0) return;
    // The track alpha must not attenuate the gradient's completed arc.
    paint.color = Colors.white;
    paint.shader = const SweepGradient(
      colors: [MyColors.tertiary, MyColors.tertiaryLight],
      transform: GradientRotation(-math.pi / 2),
    ).createShader(rect);
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, paint);
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.track != track;
}

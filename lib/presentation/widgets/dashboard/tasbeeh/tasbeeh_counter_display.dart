import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

class TasbeehCounterDisplay extends StatelessWidget {
  const TasbeehCounterDisplay({
    super.key,
    required this.count,
    required this.target,
    required this.progress,
    required this.phraseArabic,
    required this.phraseLabel,
    required this.isTargetReached,
    required this.isDark,
    required this.onTap,
  });

  final int count;
  final int target;
  final double progress;
  final String phraseArabic;
  final String phraseLabel;
  final bool isTargetReached;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final foreground = isDark ? Colors.white : MyColors.textPrimary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final diameter = constraints.maxWidth.clamp(246.0, 330.0).toDouble();

        return Center(
          child: GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: diameter,
              height: diameter,
              child: CustomPaint(
                painter: _TasbeehRingPainter(
                  progress: progress,
                  isDark: isDark,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: isDark
                            ? const [
                                Color(0xFF2C1D55),
                                Color(0xFF1A0E3B),
                                Color(0xFF0B0420),
                              ]
                            : const [
                                Colors.white,
                                Color(0xFFFFF4F9),
                                Color(0xFFEFE8FF),
                              ],
                      ),
                      border: Border.all(
                        color: (isDark ? Colors.white : MyColors.primary)
                            .withValues(alpha: isDark ? 0.08 : 0.07),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: MyColors.secondary.withValues(
                            alpha: isDark ? 0.22 : 0.12,
                          ),
                          blurRadius: 36,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            phraseArabic,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.amiri(
                              context,
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: foreground,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            phraseLabel,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.labelMedium.copyWith(
                              color: foreground.withValues(alpha: 0.64),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '$count',
                              style: AppTheme.sora(
                                context,
                                fontSize: 78,
                                fontWeight: FontWeight.w900,
                                color: foreground,
                                height: 0.9,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _CounterBadge(
                            label: isTargetReached
                                ? context.l10n.tasbeehTargetReached
                                : '${context.l10n.tasbeehTarget} $target',
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CounterBadge extends StatelessWidget {
  const _CounterBadge({required this.label, required this.isDark});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: MyColors.tertiary.withValues(alpha: isDark ? 0.16 : 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: MyColors.tertiary.withValues(alpha: isDark ? 0.26 : 0.22),
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: text.labelSmall.copyWith(
          color: isDark ? MyColors.tertiaryLight : MyColors.tertiaryDark,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _TasbeehRingPainter extends CustomPainter {
  const _TasbeehRingPainter({required this.progress, required this.isDark});

  final double progress;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 - 8;
    final trackPaint = Paint()
      ..color = (isDark ? Colors.white : MyColors.primary).withValues(
        alpha: isDark ? 0.08 : 0.08,
      )
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;

    final progressPaint = Paint()
      ..shader = const SweepGradient(
        colors: [MyColors.tertiary, MyColors.secondary, MyColors.primaryLight],
        stops: [0, 0.48, 1],
        startAngle: -math.pi / 2,
        endAngle: math.pi * 1.5,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TasbeehRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}

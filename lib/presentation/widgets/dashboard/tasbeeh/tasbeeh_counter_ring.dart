import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import 'tasbeeh_ring_painter.dart';
import 'tasbeeh_visuals.dart';

class TasbeehCounterRing extends StatelessWidget {
  const TasbeehCounterRing({
    super.key,
    required this.count,
    required this.target,
    required this.progress,
    required this.isTargetReached,
    this.diameter = 210,
    this.onHero = false,
  });
  final int count;
  final int target;
  final double progress;
  final bool isTargetReached;
  final double diameter;
  final bool onHero;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    final foreground = onHero ? Colors.white : colors.onSurface;
    final accent = onHero ? TasbeehVisuals.gold : colors.primary;
    return SizedBox.square(
      dimension: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: TasbeehRingPainter(progress: progress, onHero: onHero),
            ),
          ),
          Container(
            width: diameter * 0.73,
            height: diameter * 0.73,
            alignment: Alignment.center,
            padding: EdgeInsets.all(diameter * 0.06),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: onHero
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.14),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                    )
                  : null,
              color: onHero ? null : colors.surface,
              border: Border.all(
                color: onHero
                    ? Colors.white.withValues(alpha: 0.25)
                    : colors.outlineVariant,
                width: 1,
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: diameter * 0.6,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '$count',
                        style: AppTheme.sora(
                          context,
                          fontSize: diameter * 0.305,
                          fontWeight: FontWeight.w800,
                          color: foreground,
                          height: 0.95,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isTargetReached
                              ? CupertinoIcons.checkmark_circle_fill
                              : CupertinoIcons.scope,
                          size: 15,
                          color: accent,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            isTargetReached
                                ? context.l10n.tasbeehTargetReached
                                : '${context.l10n.tasbeehTarget} $target',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.labelSmall.copyWith(
                              color: accent,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
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

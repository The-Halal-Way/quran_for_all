import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';

class TasbeehCounterRing extends StatelessWidget {
  const TasbeehCounterRing({
    super.key,
    required this.count,
    required this.target,
    required this.progress,
    required this.isTargetReached,
    this.diameter = 210,
  });
  final int count;
  final int target;
  final double progress;
  final bool isTargetReached;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    return SizedBox.square(
      dimension: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: diameter * 0.04,
              strokeCap: StrokeCap.round,
              backgroundColor: colors.primary.withValues(alpha: 0.1),
              color: colors.primary,
            ),
          ),
          Container(
            width: diameter * 0.83,
            height: diameter * 0.83,
            alignment: Alignment.center,
            padding: EdgeInsets.all(diameter * 0.06),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surface,
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.4),
                width: 0.5,
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: diameter * 0.65,
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
                          color: colors.onSurface,
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
                          color: colors.primary,
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
                              color: colors.primary,
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

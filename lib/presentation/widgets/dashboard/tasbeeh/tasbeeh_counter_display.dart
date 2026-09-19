import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

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
    final colors = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);

    return Semantics(
      button: true,
      label: '$phraseLabel, $count, ${context.l10n.tasbeehTarget} $target',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLow.withValues(
              alpha: isDark ? 0.9 : 0.96,
            ),
            borderRadius: BorderRadius.circular(AppRadius.xxl),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.55),
              width: 0.7,
            ),
          ),
          child: Column(
            children: [
              Text(
                phraseArabic,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.amiri(
                  context,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                phraseLabel,
                style: text.labelLarge.copyWith(
                  color: colors.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox.square(
                dimension: 210,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 10,
                        strokeCap: StrokeCap.round,
                        backgroundColor: colors.primary.withValues(alpha: 0.1),
                        color: colors.primary,
                      ),
                    ),
                    Container(
                      width: 174,
                      height: 174,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.surface,
                        border: Border.all(
                          color: colors.outlineVariant.withValues(alpha: 0.4),
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '$count',
                              style: AppTheme.sora(
                                context,
                                fontSize: 64,
                                fontWeight: FontWeight.w800,
                                color: colors.onSurface,
                                height: 0.95,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isTargetReached
                                    ? CupertinoIcons.checkmark_circle_fill
                                    : CupertinoIcons.scope,
                                size: 15,
                                color: colors.primary,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                isTargetReached
                                    ? context.l10n.tasbeehTargetReached
                                    : '${context.l10n.tasbeehTarget} $target',
                                style: text.labelSmall.copyWith(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Icon(
                CupertinoIcons.add_circled_solid,
                size: 19,
                color: colors.onSurfaceVariant.withValues(alpha: 0.62),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

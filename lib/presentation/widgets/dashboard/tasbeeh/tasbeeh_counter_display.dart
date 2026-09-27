import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import 'tasbeeh_counter_ring.dart';

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
        key: const ValueKey('tasbeeh_count_area'),
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
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
              if (phraseArabic.isNotEmpty) ...[
                Text(
                  phraseArabic,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  maxLines: 2,
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
              ],
              Text(
                phraseLabel,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    (phraseArabic.isEmpty ? text.titleLarge : text.labelLarge)
                        .copyWith(
                          color: phraseArabic.isEmpty
                              ? colors.onSurface
                              : colors.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TasbeehCounterRing(
                count: count,
                target: target,
                progress: progress,
                isTargetReached: isTargetReached,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.add_circled_solid,
                    size: 17,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      context.l10n.tasbeehTapToCount,
                      textAlign: TextAlign.center,
                      style: text.labelSmall.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

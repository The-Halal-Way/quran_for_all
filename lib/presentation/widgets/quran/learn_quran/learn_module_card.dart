import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/learn_quran_content.dart';
import 'learn_module_visuals.dart';

class LearnModuleCard extends StatelessWidget {
  const LearnModuleCard({
    super.key,
    required this.module,
    required this.completedLessons,
    required this.onTap,
  });

  final LearnQuranModule module;
  final int completedLessons;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final visuals = LearnModuleVisuals.forModule(module.id);
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark
        ? Color.lerp(visuals.startColor, Colors.white, 0.38)!
        : visuals.startColor;
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
    final progress = module.lessons.isEmpty
        ? 0.0
        : completedLessons / module.lessons.length;

    final statusText = completedLessons == module.lessons.length
        ? l10n.learnModuleStatusCompleted
        : completedLessons == 0
        ? l10n.learnModuleStatusNotStarted
        : l10n.learnModuleStatusInProgress;

    return Semantics(
      button: true,
      onTap: onTap,
      excludeSemantics: true,
      label:
          '${context.learnText(module.title)}. '
          '${context.learnText(module.subtitle)}. $statusText. '
          '${l10n.learnCompletedFraction(completedLessons, module.lessons.length)}',
      child: Tooltip(
        message: context.learnText(module.title),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.md,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Ink(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          visuals.startColor.withValues(
                            alpha: isDark ? 0.28 : 0.18,
                          ),
                          visuals.endColor.withValues(
                            alpha: isDark ? 0.16 : 0.10,
                          ),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: accent.withValues(alpha: isDark ? 0.38 : 0.22),
                      ),
                    ),
                    child: Icon(visuals.icon, color: accent, size: 26),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    context.learnText(module.title),
                    maxLines: scale > 1.4 ? 3 : 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTheme.text(context).titleSmall.copyWith(
                      fontWeight: AppTheme.weightBold,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    child: LinearProgressIndicator(
                      minHeight: 4,
                      value: progress,
                      backgroundColor: accent.withValues(alpha: 0.12),
                      color: accent,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.learnCompletedFraction(
                      completedLessons,
                      module.lessons.length,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTheme.text(context).labelSmall.copyWith(
                      color: accent,
                      fontWeight: AppTheme.weightBold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_responsive.dart';
import '../../../data/models/learn_quran_content.dart';
import '../common/app_pill.dart';
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
    final responsive = AppResponsive.of(context);
    final leadingSize = responsive.pick(mobile: 44, tablet: 40, desktop: 46);
    final progressHeight = responsive.pick(
      mobile: 8,
      tablet: 7.4,
      desktop: 8.2,
    );
    final progress = module.lessons.isEmpty
        ? 0.0
        : completedLessons / module.lessons.length;

    final statusText = completedLessons == module.lessons.length
        ? l10n.learnModuleStatusCompleted
        : completedLessons == 0
        ? l10n.learnModuleStatusNotStarted
        : l10n.learnModuleStatusInProgress;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg - 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: leadingSize,
                    height: leadingSize,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          visuals.startColor.withValues(alpha: 0.23),
                          visuals.endColor.withValues(alpha: 0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.base),
                    ),
                    child: Icon(visuals.icon, color: visuals.startColor),
                  ),
                  const SizedBox(width: AppSpacing.sm + 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.learnText(module.title),
                          style: AppTheme.text(context).titleMedium.copyWith(
                            fontWeight: AppTheme.weightBold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs - 1),
                        Text(
                          context.learnText(module.subtitle),
                          style: AppTheme.text(context).bodySmall.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.74),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                context.learnText(module.description),
                style: AppTheme.text(context).bodyMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  AppPill.surface(
                    icon: Icons.schedule_rounded,
                    label: l10n.learnMinutesShort(module.estimatedMinutes),
                  ),
                  AppPill.surface(
                    icon: Icons.signal_cellular_alt_rounded,
                    label: context.learnText(module.level),
                  ),
                  AppPill.surface(
                    icon: Icons.task_alt_rounded,
                    label: l10n.learnCompletedFraction(
                      completedLessons,
                      module.lessons.length,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: LinearProgressIndicator(
                  minHeight: progressHeight,
                  value: progress,
                  backgroundColor: visuals.startColor.withValues(alpha: 0.15),
                  color: visuals.endColor,
                ),
              ),
              const SizedBox(height: AppSpacing.sm - 1),
              Text(
                statusText,
                style: AppTheme.text(context).labelMedium.copyWith(
                  color: visuals.startColor,
                  fontWeight: AppTheme.weightBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../data/models/learn_quran_content.dart';
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
    final progress = module.lessons.isEmpty
        ? 0.0
        : completedLessons / module.lessons.length;

    final statusText = completedLessons == module.lessons.length
        ? 'Completed'
        : completedLessons == 0
        ? 'Not started'
        : 'In progress';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          visuals.startColor.withValues(alpha: 0.23),
                          visuals.endColor.withValues(alpha: 0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(visuals.icon, color: visuals.startColor),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          module.subtitle,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.74),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                module.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _DataBadge(
                    icon: Icons.schedule_rounded,
                    label: '${module.estimatedMinutes} min',
                  ),
                  const SizedBox(width: 8),
                  _DataBadge(
                    icon: Icons.signal_cellular_alt_rounded,
                    label: module.level,
                  ),
                  const SizedBox(width: 8),
                  _DataBadge(
                    icon: Icons.task_alt_rounded,
                    label: '$completedLessons/${module.lessons.length}',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  value: progress,
                  backgroundColor: visuals.startColor.withValues(alpha: 0.15),
                  color: visuals.endColor,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                statusText,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: visuals.startColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DataBadge extends StatelessWidget {
  const _DataBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        color: colorScheme.primary.withValues(alpha: 0.09),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extensions.dart';

class LearnHeaderCard extends StatelessWidget {
  const LearnHeaderCard({
    super.key,
    required this.overallProgress,
    required this.completedLessons,
    required this.totalLessons,
    required this.completedModules,
    required this.totalModules,
    required this.streakDays,
  });

  final double overallProgress;
  final int completedLessons;
  final int totalLessons;
  final int completedModules;
  final int totalModules;
  final int streakDays;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B6B5A), Color(0xFFBC5B40)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2E0B6B5A),
            blurRadius: 22,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.learnHeaderTitle,
            style: textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontSize: 30,
              height: 1.12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.learnHeaderSubtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: overallProgress,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              color: const Color(0xFFFFD48A),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.learnHeaderLessonProgress(completedLessons, totalLessons),
            style: textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MetricPill(
                  icon: Icons.workspace_premium_rounded,
                  label: l10n.learnHeaderModulesLabel,
                  value: '$completedModules/$totalModules',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricPill(
                  icon: Icons.local_fire_department_rounded,
                  label: l10n.learnHeaderStreakLabel,
                  value: l10n.learnHeaderStreakDays(streakDays),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.32)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/quran/quran_hub_models.dart';

/// A compact, high-contrast CTA tile for the two primary entry points of the
/// app (Read Quran / Learn Quran). Keeps the whole card scannable in one
/// glance: icon, title, a short subtitle and a metric, all on a vibrant
/// gradient that makes the action stand out immediately.
class QuranPathCard extends StatelessWidget {
  const QuranPathCard({super.key, required this.action, required this.onTap});

  final QuranHubAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            gradient: LinearGradient(
              colors: [action.accent, action.secondaryAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: action.accent.withValues(alpha: 0.32),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _IconBadge(action: action),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              action.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: text.titleMedium.copyWith(
                                color: Colors.white,
                                fontWeight: AppTheme.weightExtraBold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _MetricPill(action: action),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        action.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.88),
                        ),
                      ),
                      if (action.progress != null) ...[
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          child: LinearProgressIndicator(
                            value: action.progress!.clamp(0, 1),
                            minHeight: 4,
                            color: Colors.white,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.22,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _ArrowButton(accent: action.accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.action});

  final QuranHubAction action;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadius.relaxed),
      ),
      child: Center(
        child: Image.asset(
          action.iconAsset,
          width: 24,
          height: 24,
          color: Colors.white,
          errorBuilder: (context, error, stackTrace) =>
              Icon(action.icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({required this.action});

  final QuranHubAction action;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            action.metricValue,
            style: text.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.weightExtraBold,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            action.metricLabel,
            style: text.labelSmall.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.base),
      ),
      child: Icon(Icons.arrow_forward_rounded, color: accent, size: 19),
    );
  }
}

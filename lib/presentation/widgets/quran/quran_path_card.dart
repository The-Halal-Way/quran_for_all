import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/my_colors.dart';
import '../../../data/models/quran/quran_hub_models.dart';

class QuranPathCard extends StatelessWidget {
  const QuranPathCard({super.key, required this.action, required this.onTap});

  final QuranHubAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? MyColors.darkCardFill : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : MyColors.divider.withValues(alpha: 0.78);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Ink(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: action.accent.withValues(alpha: isDark ? 0.16 : 0.10),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    gradient: LinearGradient(
                      colors: [
                        action.accent.withValues(alpha: isDark ? 0.18 : 0.10),
                        action.secondaryAccent.withValues(
                          alpha: isDark ? 0.18 : 0.08,
                        ),
                        Colors.transparent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _IconBadge(action: action),
                        const Spacer(),
                        _MetricPill(action: action),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      action.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleMedium.copyWith(
                        color: isDark
                            ? MyColors.darkTextPrimary
                            : MyColors.textPrimary,
                        fontWeight: AppTheme.weightExtraBold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      action.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodyMedium.copyWith(
                        color: isDark
                            ? MyColors.darkTextSecondary
                            : MyColors.textSecondary,
                        height: 1.42,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _DetailRow(action: action),
                    if (action.progress != null) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        child: LinearProgressIndicator(
                          value: action.progress!.clamp(0, 1),
                          minHeight: 6,
                          color: action.accent,
                          backgroundColor: action.accent.withValues(
                            alpha: 0.14,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    _ActionFooter(action: action),
                  ],
                ),
              ),
            ],
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
        gradient: LinearGradient(
          colors: [action.accent, action.secondaryAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.relaxed),
      ),
      child: Center(
        child: Image.asset(
          action.iconAsset,
          width: 25,
          height: 25,
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: action.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: action.accent.withValues(alpha: 0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            action.metricValue,
            style: text.labelMedium.copyWith(
              color: action.accent,
              fontWeight: AppTheme.weightExtraBold,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            action.metricLabel,
            style: text.labelSmall.copyWith(color: action.accent),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.action});

  final QuranHubAction action;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Row(
      children: [
        Icon(Icons.auto_awesome_rounded, color: action.accent, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            action.detail,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.labelMedium.copyWith(
              color: action.accent,
              fontWeight: AppTheme.weightBold,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionFooter extends StatelessWidget {
  const _ActionFooter({required this.action});

  final QuranHubAction action;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            action.actionLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.labelLarge.copyWith(
              color: action.accent,
              fontWeight: AppTheme.weightExtraBold,
            ),
          ),
        ),
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: action.accent,
            borderRadius: BorderRadius.circular(AppRadius.base),
          ),
          child: const Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white,
            size: 19,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

class TasbeehStatsPanel extends StatelessWidget {
  const TasbeehStatsPanel({
    super.key,
    required this.totalCount,
    required this.completedRounds,
    required this.currentCount,
    required this.isDark,
  });

  final int totalCount;
  final int completedRounds;
  final int currentCount;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final foreground = isDark ? Colors.white : MyColors.textPrimary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isDark ? MyColors.darkCardFill : Colors.white).withValues(
          alpha: isDark ? 0.86 : 0.92,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isDark ? Colors.white : MyColors.divider).withValues(
            alpha: isDark ? 0.07 : 0.82,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withValues(alpha: isDark ? 0.14 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _Metric(
              label: context.l10n.tasbeehCurrent,
              value: '$currentCount',
              color: MyColors.secondary,
              foreground: foreground,
            ),
          ),
          _Divider(isDark: isDark),
          Expanded(
            child: _Metric(
              label: context.l10n.tasbeehTotal,
              value: '$totalCount',
              color: MyColors.tertiary,
              foreground: foreground,
            ),
          ),
          _Divider(isDark: isDark),
          Expanded(
            child: _Metric(
              label: context.l10n.tasbeehRounds,
              value: '$completedRounds',
              color: MyColors.primaryLight,
              foreground: foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.color,
    required this.foreground,
  });

  final String label;
  final String value;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Column(
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: text.titleLarge.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: text.labelSmall.copyWith(
            color: foreground.withValues(alpha: 0.58),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 42,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: (isDark ? Colors.white : MyColors.divider).withValues(
        alpha: isDark ? 0.08 : 0.9,
      ),
    );
  }
}

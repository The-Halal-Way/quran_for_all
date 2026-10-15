import 'package:flutter/material.dart';

import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import 'wudu_step_type.dart';
import 'wudu_step_visual.dart';

class WuduStepCard extends StatelessWidget {
  const WuduStepCard({
    super.key,
    required this.number,
    required this.type,
    required this.title,
    required this.body,
    required this.accent,
  });

  final int number;
  final WuduStepType type;
  final String title;
  final String body;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
        boxShadow: AppShadows.card(tint: accent),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 620;
          final copy = _WuduStepCopy(
            number: number,
            title: title,
            body: body,
            accent: accent,
          );
          final visual = WuduStepVisual(
            type: type,
            accent: accent,
            fallbackLabel: title,
          );

          return Flex(
            direction: wide ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: wide
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.stretch,
            children: [
              if (wide) Expanded(child: copy) else copy,
              if (wide) const SizedBox(width: AppSpacing.lg),
              if (!wide) const SizedBox(height: AppSpacing.md),
              if (wide)
                SizedBox(width: 220, child: visual)
              else
                SizedBox(height: 142, child: visual),
            ],
          );
        },
      ),
    );
  }
}

class _WuduStepCopy extends StatelessWidget {
  const _WuduStepCopy({
    required this.number,
    required this.title,
    required this.body,
    required this.accent,
  });

  final int number;
  final String title;
  final String body;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.13),
                shape: BoxShape.circle,
                border: Border.all(color: accent.withValues(alpha: 0.3)),
              ),
              child: Center(
                child: Text(
                  '$number',
                  style: text.titleMedium.copyWith(
                    color: accent,
                    fontWeight: AppTheme.weightExtraBold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                title,
                style: text.titleMedium.copyWith(
                  fontWeight: AppTheme.weightExtraBold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(body, style: text.bodyMedium.copyWith(height: 1.55)),
      ],
    );
  }
}

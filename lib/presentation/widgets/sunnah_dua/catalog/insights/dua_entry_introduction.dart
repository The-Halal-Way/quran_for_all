import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/dua/dua_catalog.dart';
import '../dua_entry_benefits.dart';
import 'dua_insight_palette.dart';
import 'dua_insight_references.dart';

class DuaEntryIntroduction extends StatelessWidget {
  const DuaEntryIntroduction({super.key, required this.entry});
  final DuaEntry entry;

  @override
  Widget build(BuildContext context) {
    final insight = entry.insights;
    if (!insight.hasIntroduction) return DuaEntryBenefits(entry: entry);
    final language = context.l10n.localeName;
    final text = AppTheme.text(context);
    final scheme = Theme.of(context).colorScheme;
    final accent = duaInsightAccent(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!insight.purpose.isEmpty)
            Container(
              key: const ValueKey('dua-insight-purpose'),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                  accent.withValues(alpha: .065),
                  scheme.surface,
                ),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: accent.withValues(alpha: .14)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.duaPurposeLabel,
                    style: text.labelSmall.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    insight.purpose.inLanguage(language),
                    style: text.titleMedium.copyWith(
                      color: accent,
                      height: 1.65,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          for (final (index, virtue) in insight.reportedVirtues.indexed) ...[
            const SizedBox(height: AppSpacing.xl),
            Text(
              context.l10n.duaReportedVirtueLabel,
              style: text.labelMedium.copyWith(
                color: accent,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              key: ValueKey('dua-insight-virtue-$index'),
              padding: const EdgeInsetsDirectional.only(start: 16),
              decoration: BoxDecoration(
                border: BorderDirectional(
                  start: BorderSide(
                    color: accent.withValues(alpha: .45),
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                virtue.text.inLanguage(language),
                style: text.bodyLarge.copyWith(
                  color: scheme.onSurface,
                  height: 1.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            DuaInsightReferences(references: virtue.references),
          ],
          if (insight.reportedVirtues.isEmpty &&
              !insight.significance.isEmpty) ...[
            const SizedBox(height: AppSpacing.xl),
            Text(
              context.l10n.duaMeaningReflection,
              style: text.labelMedium.copyWith(
                color: accent,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              insight.significance.inLanguage(language),
              key: const ValueKey('dua-insight-reflection'),
              style: text.bodyLarge.copyWith(height: 1.8),
            ),
          ],
          if (!insight.evidenceNote.isEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Container(
              key: const ValueKey('dua-insight-evidence-note'),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: scheme.tertiaryContainer.withValues(alpha: .35),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Text(
                insight.evidenceNote.inLanguage(language),
                style: text.bodyMedium.copyWith(height: 1.65),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

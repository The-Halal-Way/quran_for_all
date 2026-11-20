import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/dua/dua_catalog.dart';
import '../dua_detail_section.dart';
import 'dua_insight_palette.dart';
import 'dua_insight_references.dart';

class DuaEntryBackground extends StatelessWidget {
  const DuaEntryBackground({super.key, required this.entry});
  final DuaEntry entry;

  @override
  Widget build(BuildContext context) {
    final insight = entry.insights;
    final language = context.l10n.localeName;
    final text = AppTheme.text(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (insight.reportedVirtues.isNotEmpty && !insight.significance.isEmpty)
          DuaDetailSection(
            title: context.l10n.duaMeaningReflection,
            child: Text(
              insight.significance.inLanguage(language),
              key: const ValueKey('dua-insight-reflection'),
              style: text.bodyLarge.copyWith(height: 1.8),
            ),
          ),
        if (!insight.background.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: duaInsightAccent(context).withValues(alpha: .15),
                ),
              ),
              child: ExpansionTile(
                key: PageStorageKey('dua-background-${entry.id}'),
                shape: const Border(),
                collapsedShape: const Border(),
                leading: Icon(
                  Icons.auto_stories_outlined,
                  color: duaInsightAccent(context),
                ),
                title: Text(
                  context.l10n.duaBackgroundTitle,
                  style: text.titleSmall.copyWith(fontWeight: FontWeight.w700),
                ),
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insight.background.inLanguage(language),
                    key: const ValueKey('dua-insight-background'),
                    style: text.bodyLarge.copyWith(height: 1.8),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DuaInsightReferences(
                    references: insight.backgroundReferences,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

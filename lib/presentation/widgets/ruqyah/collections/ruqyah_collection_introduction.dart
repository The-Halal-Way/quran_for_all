import 'package:flutter/material.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/ruqyah/ruqyah_routine.dart';
import '../shared/ruqyah_panel.dart';
import '../shared/ruqyah_sources.dart';
import '../shared/ruqyah_style.dart';

class RuqyahCollectionIntroduction extends StatelessWidget {
  const RuqyahCollectionIntroduction({super.key, required this.routine});
  final RuqyahRoutine routine;
  @override
  Widget build(BuildContext context) {
    final totals = routine.summary.collection!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: RuqyahPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              routine.summary.title.inLanguage(context.l10n.localeName),
              style: AppTheme.text(
                context,
              ).titleLarge.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(
              context.l10n.ruqyahCollectionCounts(
                RuqyahStyle.number(context, totals.verseCount),
                RuqyahStyle.number(context, totals.surahCount),
              ),
              style: AppTheme.text(
                context,
              ).labelLarge.copyWith(color: RuqyahStyle.accent(context)),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.ruqyahCollectionNote,
              style: AppTheme.text(context).bodyMedium.copyWith(height: 1.6),
            ),
            ExpansionTile(
              key: PageStorageKey('collection-sources-${routine.summary.id}'),
              tilePadding: EdgeInsets.zero,
              shape: const Border(),
              collapsedShape: const Border(),
              title: Text(
                context.l10n.ruqyahSources,
                style: AppTheme.text(context).labelLarge,
              ),
              children: [RuqyahSources(sources: routine.sources)],
            ),
          ],
        ),
      ),
    );
  }
}

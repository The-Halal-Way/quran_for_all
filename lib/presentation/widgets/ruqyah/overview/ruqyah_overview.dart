import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../viewmodels/ruqyah/ruqyah_viewmodel.dart';
import '../shared/ruqyah_panel.dart';
import '../shared/ruqyah_style.dart';
import '../guides/ruqyah_guide_card.dart';
import 'ruqyah_hero.dart';
import 'ruqyah_routine_card.dart';
import '../collections/ruqyah_collections_section.dart';

class RuqyahOverview extends StatelessWidget {
  const RuqyahOverview({
    super.key,
    required this.model,
    required this.onOpen,
    required this.onResume,
    required this.onGuide,
  });
  final RuqyahViewModel model;
  final ValueChanged<String> onOpen;
  final VoidCallback onResume;
  final ValueChanged<String> onGuide;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const RuqyahHero(),
      if (model.progress != null) ...[
        const SizedBox(height: 16),
        RuqyahPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bookmark_rounded,
                    color: RuqyahStyle.accent(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.l10n.ruqyahContinue,
                      style: AppTheme.text(
                        context,
                      ).titleSmall.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                model.progress!.routineId == null
                    ? context.l10n.ruqyahLibrary
                    : model.index!.routines
                          .firstWhere(
                            (r) => r.id == model.progress!.routineId,
                            orElse: () => model.index!.routines.first,
                          )
                          .title
                          .inLanguage(context.l10n.localeName),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value:
                    model.progress!.completed.length / model.progress!.length,
                color: RuqyahStyle.accent(context),
              ),
              const SizedBox(height: 10),
              Text(
                context.l10n.ruqyahResumeBody,
                style: AppTheme.text(context).bodySmall,
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: onResume,
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(context.l10n.ruqyahContinue),
              ),
            ],
          ),
        ),
      ],
      const SizedBox(height: 24),
      RuqyahCollectionsSection(
        collections: model.index!.routines
            .where((r) => r.collection != null)
            .toList(),
        onOpen: onOpen,
        onGuide: onGuide,
      ),
      const SizedBox(height: 16),
      for (final group in ['care', 'daily']) ...[
        Text(
          group == 'care'
              ? context.l10n.ruqyahCareMethods
              : context.l10n.ruqyahDailyMethods,
          style: AppTheme.text(
            context,
          ).titleLarge.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 14),
        for (final (i, routine)
            in model.index!.routines.where((r) => r.group == group).indexed)
          RuqyahRoutineCard(
            routine: routine,
            index: i,
            onTap: () => onOpen(routine.id),
            onMethod: () => onGuide(routine.guideId),
          ),
        const SizedBox(height: 12),
      ],
      Text(
        context.l10n.ruqyahUnderstand,
        style: AppTheme.text(
          context,
        ).titleLarge.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 14),
      for (final id in model.index!.featuredGuideIds)
        for (final guide in model.index!.guides.where((g) => g.id == id))
          RuqyahGuideCard(
            title: guide.title.inLanguage(context.l10n.localeName),
            summary: guide.summary.inLanguage(context.l10n.localeName),
            basis: guide.basis,
            onTap: () => onGuide(guide.id),
          ),
      const SizedBox(height: 4),
      Text(
        context.l10n.ruqyahCareNote,
        style: AppTheme.text(context).bodySmall.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          height: 1.5,
        ),
      ),
    ],
  );
}

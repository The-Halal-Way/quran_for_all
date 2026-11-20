import 'package:flutter/material.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/ruqyah/ruqyah_guide.dart';
import '../shared/ruqyah_panel.dart';
import '../shared/ruqyah_sources.dart';
import '../shared/ruqyah_style.dart';

class RuqyahArticleSection extends StatelessWidget {
  const RuqyahArticleSection({
    super.key,
    required this.section,
    required this.number,
  });
  final RuqyahGuideSection section;
  final int number;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: RuqyahPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            RuqyahStyle.number(context, number),
            style: AppTheme.text(
              context,
            ).labelLarge.copyWith(color: RuqyahStyle.accent(context)),
          ),
          const SizedBox(height: 8),
          Text(
            section.title,
            style: AppTheme.text(
              context,
            ).titleMedium.copyWith(fontWeight: FontWeight.w800, height: 1.4),
          ),
          const SizedBox(height: 12),
          Text(
            section.text,
            style: AppTheme.text(context).bodyLarge.copyWith(height: 1.75),
          ),
          for (final point in section.points)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•  ',
                    style: TextStyle(color: RuqyahStyle.accent(context)),
                  ),
                  Expanded(
                    child: Text(
                      point,
                      style: AppTheme.text(
                        context,
                      ).bodyMedium.copyWith(height: 1.6),
                    ),
                  ),
                ],
              ),
            ),
          if (section.sources.isNotEmpty) ...[
            const SizedBox(height: 14),
            ExpansionTile(
              key: PageStorageKey('ruqyah-article-source-${section.title}'),
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              shape: const Border(),
              collapsedShape: const Border(),
              title: Text(
                context.l10n.ruqyahSources,
                style: AppTheme.text(context).labelLarge,
              ),
              children: [RuqyahSources(sources: section.sources)],
            ),
          ],
        ],
      ),
    ),
  );
}

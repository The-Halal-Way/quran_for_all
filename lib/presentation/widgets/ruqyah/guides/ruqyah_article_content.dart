import 'package:flutter/material.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/ruqyah/ruqyah_guide.dart';
import '../../../../data/models/ruqyah/ruqyah_index.dart';
import '../shared/ruqyah_evidence_label.dart';
import '../shared/ruqyah_panel.dart';
import '../shared/ruqyah_style.dart';
import 'ruqyah_article_section.dart';

class RuqyahArticleContent extends StatefulWidget {
  const RuqyahArticleContent({
    super.key,
    required this.guide,
    required this.index,
    required this.onRoutine,
    required this.onReading,
  });
  final RuqyahGuide guide;
  final RuqyahIndex index;
  final ValueChanged<String> onRoutine, onReading;
  @override
  State<RuqyahArticleContent> createState() => _RuqyahArticleContentState();
}

class _RuqyahArticleContentState extends State<RuqyahArticleContent> {
  late List<GlobalKey> _sections;
  @override
  void initState() {
    super.initState();
    _resetSections();
  }

  void _resetSections() => _sections = List.generate(
    widget.guide.sections.length,
    (_) => GlobalKey(),
  );
  @override
  void didUpdateWidget(covariant RuqyahArticleContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.guide != widget.guide) _resetSections();
  }

  @override
  Widget build(BuildContext context) {
    final guide = widget.guide;
    final lang = context.l10n.localeName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RuqyahPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RuqyahEvidenceLabel(basis: guide.basis),
              const SizedBox(height: 12),
              Text(
                guide.title,
                style: AppTheme.text(
                  context,
                ).titleLarge.copyWith(height: 1.3, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text(
                guide.summary,
                style: AppTheme.text(context).bodyLarge.copyWith(
                  height: 1.6,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (var i = 0; i < guide.sections.length; i++)
              ActionChip(
                label: Text(guide.sections[i].title),
                onPressed: () {
                  final target = _sections[i].currentContext;
                  if (target != null) {
                    Scrollable.ensureVisible(
                      target,
                      duration: const Duration(milliseconds: 300),
                      alignment: .03,
                    );
                  }
                },
              ),
          ],
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < guide.sections.length; i++)
          RuqyahArticleSection(
            key: _sections[i],
            section: guide.sections[i],
            number: i + 1,
          ),
        if (guide.routineIds.isNotEmpty) ...[
          Text(
            context.l10n.ruqyahRelatedMethods,
            style: AppTheme.text(context).titleMedium,
          ),
          const SizedBox(height: 8),
          for (final id in guide.routineIds)
            _RelatedLink(
              title: widget.index.routines
                  .firstWhere((r) => r.id == id)
                  .title
                  .inLanguage(lang),
              icon: Icons.play_circle_outline_rounded,
              onTap: () => widget.onRoutine(id),
            ),
        ],
        if (guide.readingIds.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            context.l10n.ruqyahRelatedReadings,
            style: AppTheme.text(context).titleMedium,
          ),
          const SizedBox(height: 8),
          for (final id in guide.readingIds)
            _RelatedLink(
              title: widget.index.readings
                  .firstWhere((r) => r.id == id)
                  .title
                  .inLanguage(lang),
              icon: Icons.menu_book_rounded,
              onTap: () => widget.onReading(id),
            ),
        ],
      ],
    );
  }
}

class _RelatedLink extends StatelessWidget {
  const _RelatedLink({
    required this.title,
    required this.icon,
    required this.onTap,
  });
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Icon(icon, color: RuqyahStyle.accent(context)),
        title: Text(title, style: AppTheme.text(context).bodyMedium),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    ),
  );
}

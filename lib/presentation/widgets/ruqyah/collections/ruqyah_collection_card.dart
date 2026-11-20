import 'package:flutter/material.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/ruqyah/ruqyah_index.dart';
import '../shared/ruqyah_style.dart';

class RuqyahCollectionCard extends StatelessWidget {
  const RuqyahCollectionCard({
    super.key,
    required this.collection,
    required this.onOpen,
    required this.onGuide,
    this.featured = false,
  });
  final RuqyahRoutineSummary collection;
  final VoidCallback onOpen, onGuide;
  final bool featured;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = RuqyahStyle.accent(context);
    final foreground = featured ? Colors.white : scheme.onSurface;
    final info = collection.collection!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: featured
              ? const LinearGradient(
                  colors: [RuqyahStyle.deep, Color(0xFF227B70)],
                )
              : null,
        ),
        child: Material(
          color: featured ? Colors.transparent : scheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: accent.withValues(alpha: .18)),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onOpen,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          collection.title.inLanguage(context.l10n.localeName),
                          style: AppTheme.text(context).titleMedium.copyWith(
                            color: foreground,
                            fontWeight: FontWeight.w800,
                            height: 1.35,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.north_east_rounded,
                        color: featured ? const Color(0xFFB7F3DF) : accent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Text(
                    context.l10n.ruqyahCollectionCounts(
                      RuqyahStyle.number(context, info.verseCount),
                      RuqyahStyle.number(context, info.surahCount),
                    ),
                    style: AppTheme.text(context).labelLarge.copyWith(
                      color: featured ? const Color(0xFFB7F3DF) : accent,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    collection.description.inLanguage(context.l10n.localeName),
                    style: AppTheme.text(context).bodySmall.copyWith(
                      color: featured
                          ? const Color(0xFFDEF5ED)
                          : scheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    children: [
                      TextButton.icon(
                        onPressed: onOpen,
                        icon: const Icon(Icons.menu_book_rounded, size: 18),
                        style: TextButton.styleFrom(
                          foregroundColor: foreground,
                        ),
                        label: Text(context.l10n.ruqyahReadContinuously),
                      ),
                      TextButton(
                        onPressed: onGuide,
                        style: TextButton.styleFrom(
                          foregroundColor: featured
                              ? const Color(0xFFB7F3DF)
                              : accent,
                        ),
                        child: Text(context.l10n.ruqyahCollectionBackground),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

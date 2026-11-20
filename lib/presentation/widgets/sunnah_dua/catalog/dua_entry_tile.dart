import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/dua/dua_catalog.dart';
import 'dua_catalog_visuals.dart';
import 'insights/dua_entry_preview.dart';

class DuaEntryTile extends StatelessWidget {
  const DuaEntryTile({
    super.key,
    required this.entry,
    required this.onTap,
    this.categoryId,
  });
  final DuaEntry entry;
  final String? categoryId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final language = context.l10n.localeName;
    final text = AppTheme.text(context);
    final color = DuaCatalogVisuals.color(
      categoryId ?? entry.categoryIds.firstOrNull ?? 'all',
    );
    final accent = Theme.of(context).brightness == Brightness.dark
        ? Color.lerp(color, Colors.white, .45)!
        : Color.lerp(color, scheme.onSurface, .3)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: accent.withValues(alpha: .18)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                Color.alphaBlend(color.withValues(alpha: .045), scheme.surface),
                scheme.surface,
              ],
            ),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.titleFor(language, categoryId),
                          style: text.titleSmall.copyWith(
                            fontWeight: AppTheme.weightExtraBold,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Icon(
                        entry.isDefault
                            ? Icons.arrow_outward_rounded
                            : Icons.info_outline_rounded,
                        color: accent,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DuaEntryPreview(entry: entry, accent: accent),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/dua/dua_catalog.dart';
import 'dua_catalog_visuals.dart';

class DuaLibraryHeader extends StatelessWidget {
  const DuaLibraryHeader({super.key, required this.catalog});
  final DuaCatalog catalog;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF155D67), Color(0xFF353B81)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.duaLibraryTitle,
                  style: text.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: AppTheme.weightExtraBold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                Icons.auto_stories_rounded,
                size: 38,
                color: Color(0xFFB9F0DF),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            catalog.description.inLanguage(context.l10n.localeName),
            style: text.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: .85),
              height: 1.55,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.xs,
            children: [
              Text(
                context.l10n.duaEntryCount(
                  duaNumber(
                    context,
                    catalog.category(catalog.allId).entryIds.length,
                  ),
                ),
                style: text.labelMedium.copyWith(
                  color: const Color(0xFFB9F0DF),
                ),
              ),
              Text(
                context.l10n.duaCategoryCount(
                  duaNumber(context, catalog.categories.length),
                ),
                style: text.labelMedium.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

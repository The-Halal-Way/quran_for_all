import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../viewmodels/science_in_quran_viewmodel.dart';
import 'science_in_quran_labels.dart';

class ScienceInQuranBookmarksSheet extends StatelessWidget {
  const ScienceInQuranBookmarksSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ScienceInQuranViewModel>();
    final pages = model.reading.bookmarks;
    final scheme = Theme.of(context).colorScheme;
    return FractionallySizedBox(
      heightFactor: 0.7,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.scienceInQuranBookmarks,
              style: AppTheme.text(context).titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.scienceInQuranPageNumberNote,
              style: AppTheme.text(context).bodySmall,
            ),
            const SizedBox(height: AppSpacing.xl),
            Expanded(
              child: pages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bookmarks_outlined,
                            size: 48,
                            color: scheme.primary,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            context.l10n.scienceInQuranBookmarksEmpty,
                            style: AppTheme.text(context).titleMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: pages.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final page = pages[index];
                        return Material(
                          color: scheme.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            leading: Icon(
                              Icons.bookmark_rounded,
                              color: scheme.primary,
                            ),
                            title: Text(
                              context.l10n.scienceInQuranPage(
                                scienceNumber(context, page),
                              ),
                            ),
                            onTap: () => Navigator.of(context).pop(page),
                            trailing: IconButton(
                              tooltip:
                                  context.l10n.scienceInQuranBookmarkRemove,
                              icon: const Icon(Icons.bookmark_remove_outlined),
                              onPressed: () => model.toggleBookmark(page),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

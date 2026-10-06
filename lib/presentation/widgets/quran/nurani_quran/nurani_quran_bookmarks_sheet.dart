import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../viewmodels/quran/nurani_quran_viewmodel.dart';
import 'nurani_quran_labels.dart';

class NuraniQuranBookmarksSheet extends StatelessWidget {
  const NuraniQuranBookmarksSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<NuraniQuranViewModel>();
    final pages = model.reading.bookmarks;
    final scheme = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
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
            Text(context.l10n.nuraniQuranBookmarks, style: text.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(context.l10n.nuraniQuranPageNumberNote, style: text.bodySmall),
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
                            context.l10n.nuraniQuranBookmarksEmpty,
                            style: text.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            context.l10n.nuraniQuranBookmarksHint,
                            textAlign: TextAlign.center,
                            style: text.bodySmall,
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
                              context.l10n.nuraniQuranPage(
                                nuraniNumber(context, page),
                              ),
                            ),
                            onTap: () => Navigator.of(context).pop(page),
                            trailing: IconButton(
                              tooltip: context.l10n.nuraniQuranBookmarkRemove,
                              icon: const Icon(Icons.bookmark_remove_outlined),
                              onPressed: () =>
                                  _removeBookmark(context, model, page),
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

  Future<void> _removeBookmark(
    BuildContext context,
    NuraniQuranViewModel model,
    int page,
  ) async {
    final saved = await model.toggleBookmark(page);
    if (!saved && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.nuraniQuranStorageError)),
      );
    }
  }
}

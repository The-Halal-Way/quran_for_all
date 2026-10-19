import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../views/dashboard/books/dashboard_books_library_view.dart';
import 'dashboard_book_cover.dart';
import 'dashboard_book_kind.dart';

class DashboardBookPreview extends StatelessWidget {
  const DashboardBookPreview({super.key, required this.book});

  final DashboardBookKind book;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: book.title(context),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          AppPageRoute<void>(
            builder: (_) => DashboardBooksLibraryView(initialBook: book),
          ),
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DashboardBookCover(
                    imagePath: book.pdfBook?.coverImage,
                    accent: book.accent,
                    width: 42,
                    height: 60,
                    fallbackLabel: book == DashboardBookKind.prophecies
                        ? '101'
                        : null,
                  ),
                  Icon(
                    Icons.arrow_outward_rounded,
                    color: book.accent,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                book.title(context),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.text(context).labelLarge.copyWith(
                  fontWeight: AppTheme.weightExtraBold,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: book.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  book.metadata(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.text(context).labelSmall.copyWith(
                    color: book.accent,
                    fontWeight: AppTheme.weightBold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

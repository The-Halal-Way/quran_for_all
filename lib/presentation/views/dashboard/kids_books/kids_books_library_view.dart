import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../widgets/common/app_page_scrollbar.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/dashboard/books/dashboard_pdf_book_card.dart';
import '../../../widgets/dashboard/kids_books/kids_book_kind.dart';
import '../../../widgets/dashboard/kids_books/kids_books_library_header.dart';

class KidsBooksLibraryView extends StatelessWidget {
  const KidsBooksLibraryView({super.key, this.initialBook});

  final KidsBookKind? initialBook;

  @override
  Widget build(BuildContext context) {
    final padding = AppResponsive.of(context).padding;
    final books = [
      ?initialBook,
      ...KidsBookKind.values.where((kind) => kind != initialBook),
    ];
    return Scaffold(
      body: AppPremiumPageBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  padding,
                  AppSpacing.sm,
                  padding,
                  AppSpacing.lg,
                ),
                child: const KidsBooksLibraryHeader(),
              ),
              Expanded(
                child: AppPageScrollbar(
                  builder: (context, controller) => ListView.separated(
                    controller: controller,
                    cacheExtent: 100,
                    padding: EdgeInsets.fromLTRB(
                      padding,
                      0,
                      padding,
                      AppSpacing.huge,
                    ),
                    itemCount: books.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.lg),
                    itemBuilder: (context, index) {
                      final kind = books[index];
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 720),
                          child: DashboardPdfBookCard(
                            key: ValueKey(kind),
                            book: kind.book,
                            accent: kind.accent,
                            description: kind.description(context),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

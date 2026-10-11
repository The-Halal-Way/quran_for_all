import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/utils/app_page_route.dart';
import '../dashboard_view/dashboard_section_title.dart';
import '../../../views/dashboard/books/dashboard_books_library_view.dart';
import 'dashboard_books_shelf.dart';

/// The compact dashboard entry point for downloadable reading material.
class DashboardBooksSection extends StatelessWidget {
  const DashboardBooksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DashboardSectionTitle(
                title: context.l10n.dashboardSectionBooks,
                icon: Icons.auto_stories_rounded,
                accent: AppThemeColors.light.cyan,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                AppPageRoute<void>(
                  builder: (_) => const DashboardBooksLibraryView(),
                ),
              ),
              child: Text(context.l10n.dashboardBooksViewAll),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const DashboardBooksShelf(),
      ],
    );
  }
}

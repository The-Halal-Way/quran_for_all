import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../views/dashboard/kids_books/kids_books_library_view.dart';
import '../dashboard_view/dashboard_section_title.dart';
import 'kids_book_kind.dart';
import 'kids_book_preview.dart';

/// Dashboard previews use only bundled covers and constant publication data.
class DashboardKidsBooksSection extends StatelessWidget {
  const DashboardKidsBooksSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: DashboardSectionTitle(
              title: context.l10n.kidsBooksSectionTitle,
              icon: Icons.child_care_rounded,
              accent: AppThemeColors.light.coral,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () => Navigator.of(context).push(
              AppPageRoute<void>(builder: (_) => const KidsBooksLibraryView()),
            ),
            child: Text(context.l10n.dashboardBooksViewAll),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.sm),
      LayoutBuilder(
        builder: (context, constraints) {
          final largeText = MediaQuery.textScalerOf(context).scale(1) > 1.3;
          final width = (constraints.maxWidth * .83).clamp(
            largeText ? 300.0 : 260.0,
            largeText ? 380.0 : 320.0,
          );
          return SingleChildScrollView(
            key: const PageStorageKey('kids-books-shelf'),
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final kind in KidsBookKind.values) ...[
                  if (kind != KidsBookKind.values.first)
                    const SizedBox(width: AppSpacing.md),
                  SizedBox(
                    width: width,
                    child: KidsBookPreview(kind: kind),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    ],
  );
}

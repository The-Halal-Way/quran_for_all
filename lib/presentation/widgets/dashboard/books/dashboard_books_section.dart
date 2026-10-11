import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../dashboard_view/dashboard_section_title.dart';
import '../science_in_quran/dashboard_science_in_quran_card.dart';

/// The dashboard shelf for downloadable reading material.
///
/// Add another independent book card to [books] when a new PDF is introduced.
class DashboardBooksSection extends StatelessWidget {
  const DashboardBooksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final books = <Widget>[const DashboardScienceInQuranCard()];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionTitle(
          title: context.l10n.dashboardSectionBooks,
          icon: Icons.auto_stories_rounded,
          accent: AppThemeColors.light.cyan,
        ),
        const SizedBox(height: AppSpacing.md),
        for (var index = 0; index < books.length; index++) ...[
          books[index],
          if (index < books.length - 1) const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

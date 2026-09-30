import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../views/dashboard/when_you_have_a_need/need_amal.dart';
import '../../../views/dashboard/when_you_have_a_need/when_you_have_a_need_view.dart';
import '../../common/app_icon_grid_section.dart';
import '../dashboard_view/dashboard_navigation.dart';

class DashboardNeedSection extends StatelessWidget {
  const DashboardNeedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isBangla = Localizations.localeOf(context).languageCode == 'bn';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    void openGuide([NeedCategory? category]) => pushDashboardPage(
      context,
      WhenYouHaveANeedView(initialCategory: category),
    );

    return AppIconGridSection(
      key: const ValueKey('dashboard_need_section'),
      title: context.l10n.dashboardNeedTitle,
      subtitle: context.l10n.dashboardNeedSubtitle,
      actionLabel: context.l10n.dashboardNeedOpen,
      onActionTap: openGuide,
      phoneColumns: 3,
      labelMaxLines: 3,
      items: [
        for (final category in NeedCategory.values)
          AppIconGridItem(
            icon: category.icon,
            label: category.title.of(isBangla),
            accent: _accentFor(category, isDark),
            onTap: () => openGuide(category),
          ),
      ],
    );
  }

  Color _accentFor(NeedCategory category, bool isDark) {
    if (isDark) {
      return switch (category) {
        NeedCategory.quran || NeedCategory.charity => MyColors.tertiaryDark,
        NeedCategory.salah || NeedCategory.specialTimes => MyColors.secondary,
        NeedCategory.dhikr || NeedCategory.dua => MyColors.primaryLight,
      };
    }
    return switch (category) {
      NeedCategory.quran => AppThemeColors.light.cyan,
      NeedCategory.salah => AppThemeColors.light.violet,
      NeedCategory.dhikr => AppThemeColors.light.brand,
      NeedCategory.dua => AppThemeColors.light.coral,
      NeedCategory.charity => AppThemeColors.light.success,
      NeedCategory.specialTimes => AppThemeColors.light.warning,
    };
  }
}

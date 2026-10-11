import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../viewmodels/settings_viewmodel.dart';
import '../../../widgets/common/app_language_action_button.dart';
import '../../../widgets/common/app_page_scrollbar.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/dashboard/books/dashboard_prophecies_card.dart';
import '../../../widgets/dashboard/science_in_quran/dashboard_science_in_quran_card.dart';

/// Full reading library opened from the compact dashboard shelf.
class DashboardBooksLibraryView extends StatelessWidget {
  const DashboardBooksLibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    final settings = context.watch<SettingsViewModel>();
    return Scaffold(
      body: AppPremiumPageBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  responsive.padding,
                  AppSpacing.sm,
                  responsive.padding,
                  0,
                ),
                child: Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).backButtonTooltip,
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.dashboardSectionBooks,
                            style: AppTheme.text(context).titleLarge.copyWith(
                              fontWeight: AppTheme.weightExtraBold,
                            ),
                          ),
                          Text(
                            context.l10n.dashboardBooksLibrarySubtitle,
                            style: AppTheme.text(context).bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.auto_stories_rounded,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    AppLanguageActionButton(
                      current: settings.settings.language,
                      onSelected: settings.setLanguage,
                      tooltip: context.l10n.settingsLanguagePanelTitle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: AppPageScrollbar(
                  builder: (context, controller) => SingleChildScrollView(
                    controller: controller,
                    padding: EdgeInsets.fromLTRB(
                      responsive.padding,
                      0,
                      responsive.padding,
                      AppSpacing.huge,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            DashboardScienceInQuranCard(),
                            SizedBox(height: AppSpacing.lg),
                            DashboardPropheciesCard(),
                          ],
                        ),
                      ),
                    ),
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

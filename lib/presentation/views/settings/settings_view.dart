import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/my_colors.dart';
import '../../../core/utils/app_responsive.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../widgets/common/app_page_scrollbar.dart';
import '../../widgets/common/app_premium_page_background.dart';
import '../../widgets/settings/settings_view/settings_content_layout.dart';
import '../../widgets/settings/settings_view/settings_hero.dart';
import '../../widgets/settings/settings_view/settings_hijri_panel.dart';
import '../../widgets/settings/settings_view/settings_offline_badge.dart';
import '../../widgets/settings/settings_view/settings_preferences_panel.dart';
import '../../widgets/settings/settings_view/settings_theme_panel.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SettingsViewModel>();
    final responsive = AppResponsive.of(context);

    return Scaffold(
      body: SafeArea(
        child: AppPremiumPageBackground(
          child: viewModel.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: MyColors.secondary),
                )
              : AppPageScrollbar(
                  builder: (context, controller) => ListView(
                    controller: controller,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      responsive.padding,
                      AppSpacing.md,
                      responsive.padding,
                      AppSpacing.huge,
                    ),
                    children: [
                      Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: responsive.maxContentWidth,
                          ),
                          child: Column(
                            children: [
                              SettingsHero(
                                onBack: embedded
                                    ? null
                                    : () => Navigator.maybePop(context),
                              ),
                              const SizedBox(height: AppSpacing.xxl),
                              SettingsContentLayout(
                                preferences: SettingsPreferencesPanel(
                                  showPronunciation:
                                      viewModel.settings.showPronunciation,
                                  showTranslation:
                                      viewModel.settings.showTranslation,
                                  language: viewModel.settings.language,
                                  onShowPronunciationChanged:
                                      viewModel.setShowPronunciation,
                                  onShowTranslationChanged:
                                      viewModel.setShowTranslation,
                                  onLanguageChanged: viewModel.setLanguage,
                                ),
                                theme: SettingsThemePanel(
                                  themeMode: viewModel.settings.themeMode,
                                  onThemeModeChanged: viewModel.setThemeMode,
                                ),
                                hijri: SettingsHijriPanel(
                                  adjustment:
                                      viewModel.settings.hijriDateAdjustment,
                                  onAdjustmentChanged:
                                      viewModel.setHijriDateAdjustment,
                                ),
                                offline: const SettingsOfflineBadge(),
                              ),
                            ],
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
}

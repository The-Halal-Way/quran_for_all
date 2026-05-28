import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_responsive.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../widgets/common/app_gradient_background.dart';
import '../../widgets/common/app_page_scrollbar.dart';
import '../../widgets/settings/settings_offline_card.dart';
import '../../widgets/settings/settings_preferences_card.dart';
import '../../widgets/settings/settings_theme_card.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, this.embedded = false});

  /// When true, shown inside bottom nav – no AppBar.
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SettingsViewModel>();
    final colorScheme = Theme.of(context).colorScheme;
    final responsive = AppResponsive.of(context);

    return Scaffold(
      appBar: embedded
          ? AppBar(title: Text(context.l10n.settingsTitle))
          : AppBar(title: Text(context.l10n.settingsTitle)),
      body: AppGradientBackground(
        child: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : AppPageScrollbar(
                builder: (context, controller) => Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: responsive.maxContentWidth,
                    ),
                    child: ListView(
                      controller: controller,
                      padding: EdgeInsets.all(responsive.padding),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            color: colorScheme.primary.withValues(alpha: 0.08),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.auto_awesome_rounded,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: AppSpacing.sm + 2),
                              Expanded(
                                child: Text(
                                  context.l10n.settingsIntro,
                                  style: AppTheme.text(context).bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SettingsPreferencesCard(
                          showPronunciation:
                              viewModel.settings.showPronunciation,
                          showTranslation: viewModel.settings.showTranslation,
                          language: viewModel.settings.language,
                          onShowPronunciationChanged:
                              viewModel.setShowPronunciation,
                          onShowTranslationChanged:
                              viewModel.setShowTranslation,
                          onLanguageChanged: viewModel.setLanguage,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SettingsThemeCard(
                          themeMode: viewModel.settings.themeMode,
                          onThemeModeChanged: viewModel.setThemeMode,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const SettingsOfflineCard(),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

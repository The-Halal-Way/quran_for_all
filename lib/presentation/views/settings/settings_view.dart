import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/settings_viewmodel.dart';
import '../../widgets/common/app_page_scrollbar.dart';
import '../../widgets/settings/settings_offline_card.dart';
import '../../widgets/settings/settings_preferences_card.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFFCF4), Color(0xFFF1E8D6)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          if (viewModel.isLoading)
            const Center(child: CircularProgressIndicator())
          else
            AppPageScrollbar(
              builder: (context, controller) => ListView(
                controller: controller,
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Personalize your recitation and reading experience.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SettingsPreferencesCard(
                    showPronunciation: viewModel.settings.showPronunciation,
                    showTranslation: viewModel.settings.showTranslation,
                    language: viewModel.settings.language,
                    onShowPronunciationChanged: viewModel.setShowPronunciation,
                    onShowTranslationChanged: viewModel.setShowTranslation,
                    onLanguageChanged: viewModel.setLanguage,
                  ),
                  const SizedBox(height: 12),
                  const SettingsOfflineCard(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

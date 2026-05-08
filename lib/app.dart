import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';

import 'core/constants/app_constants.dart';
import 'core/enums/app_language.dart';
import 'core/localization/l10n_extensions.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/local/app_database.dart';
import 'data/datasources/remote/quran_api_service.dart';
import 'data/repositories/audio_repository_impl.dart';
import 'data/repositories/learning_progress_repository_impl.dart';
import 'data/repositories/quran_repository_impl.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'domain/repositories/audio_repository.dart';
import 'domain/repositories/learning_progress_repository.dart';
import 'domain/repositories/quran_repository.dart';
import 'domain/repositories/settings_repository.dart';
import 'presentation/viewmodels/learn_quran_viewmodel.dart';
import 'presentation/viewmodels/read_quran/read_quran_viewmodel.dart';
import 'presentation/viewmodels/read_quran/search_viewmodel.dart';
import 'presentation/viewmodels/read_quran/surah_details_viewmodel.dart';
import 'presentation/viewmodels/settings_viewmodel.dart';
import 'presentation/viewmodels/splash_viewmodel.dart';
import 'presentation/views/splash/splash_view.dart';
import 'services/audio_service.dart';
import 'services/permission_helper.dart';

class QuranForAllApp extends StatelessWidget {
  const QuranForAllApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<http.Client>(
          create: (_) => http.Client(),
          dispose: (_, client) => client.close(),
        ),
        Provider<AppDatabase>(create: (_) => AppDatabase()),
        Provider<QuranApiService>(
          create: (context) => QuranApiService(context.read<http.Client>()),
        ),
        Provider<PermissionHelper>(create: (_) => const PermissionHelper()),
        Provider<AudioService>(
          create: (context) =>
              AudioService(httpClient: context.read<http.Client>()),
          dispose: (_, service) => service.dispose(),
        ),
        Provider<QuranRepository>(
          create: (context) => QuranRepositoryImpl(
            database: context.read<AppDatabase>(),
            apiService: context.read<QuranApiService>(),
          ),
        ),
        Provider<SettingsRepository>(create: (_) => SettingsRepositoryImpl()),
        Provider<LearningProgressRepository>(
          create: (_) => LearningProgressRepositoryImpl(),
        ),
        Provider<AudioRepository>(
          create: (context) =>
              AudioRepositoryImpl(context.read<AudioService>()),
        ),
        ChangeNotifierProvider<SettingsViewModel>(
          create: (context) =>
              SettingsViewModel(context.read<SettingsRepository>()),
        ),
        ChangeNotifierProvider<SplashViewModel>(
          create: (context) =>
              SplashViewModel(quranRepository: context.read<QuranRepository>()),
        ),
        ChangeNotifierProvider<ReadQuranViewModel>(
          create: (context) =>
              ReadQuranViewModel(context.read<QuranRepository>()),
        ),
        ChangeNotifierProvider<LearnQuranViewModel>(
          create: (context) => LearnQuranViewModel(
            progressRepository: context.read<LearningProgressRepository>(),
            quranRepository: context.read<QuranRepository>(),
            audioRepository: context.read<AudioRepository>(),
          ),
        ),
        ChangeNotifierProvider<SearchViewModel>(
          create: (context) => SearchViewModel(context.read<QuranRepository>()),
        ),
        ChangeNotifierProvider<SurahDetailsViewModel>(
          create: (context) => SurahDetailsViewModel(
            quranRepository: context.read<QuranRepository>(),
            audioRepository: context.read<AudioRepository>(),
          ),
        ),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsViewModel, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConstants.appName,
            theme: AppTheme.lightTheme,
            locale: Locale(settingsViewModel.settings.language.code),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) {
              final l10n = AppLocalizations.of(context);
              if (l10n != null) {
                LearnQuranTextLocalizer.seedFromLocalizations(
                  l10n,
                  Localizations.localeOf(context),
                );
              }

              return child ?? const SizedBox.shrink();
            },
            home: const SplashView(),
          );
        },
      ),
    );
  }
}

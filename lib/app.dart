import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/constants/app_constants.dart';
import 'core/enums/app_language.dart';
import 'core/localization/l10n_extensions.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_responsive.dart';
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
import 'presentation/viewmodels/audio_control_viewmodel.dart';
import 'presentation/viewmodels/dashboard_prayer_times_viewmodel.dart';
import 'presentation/viewmodels/learn_quran_viewmodel.dart';
import 'presentation/viewmodels/quran/quran_viewmodel.dart';
import 'presentation/viewmodels/read_quran/bookmarks_viewmodel.dart';
import 'presentation/viewmodels/read_quran/read_quran_viewmodel.dart';
import 'presentation/viewmodels/read_quran/search_viewmodel.dart';
import 'presentation/viewmodels/read_quran/surah_details_viewmodel.dart';
import 'presentation/viewmodels/settings_viewmodel.dart';
import 'presentation/viewmodels/splash_viewmodel.dart';
import 'presentation/views/splash/splash_view.dart';
import 'presentation/widgets/common/global_audio_control_bar.dart';
import 'services/audio_service.dart';
import 'services/permission_helper.dart';
import 'services/pronunciation_service.dart';

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
        Provider<PronunciationService>(
          create: (_) => PronunciationService(),
          dispose: (_, service) => service.dispose(),
        ),
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
        ChangeNotifierProvider<AudioControlViewModel>(
          create: (context) => AudioControlViewModel(
            audioRepository: context.read<AudioRepository>(),
          ),
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
            audioControlViewModel: context.read<AudioControlViewModel>(),
          ),
        ),
        Provider<QuranViewModel>(create: (_) => QuranViewModel()),
        ChangeNotifierProvider<SearchViewModel>(
          create: (context) => SearchViewModel(context.read<QuranRepository>()),
        ),
        ChangeNotifierProvider<BookmarksViewModel>(
          create: (context) =>
              BookmarksViewModel(context.read<QuranRepository>()),
        ),
        ChangeNotifierProvider<SurahDetailsViewModel>(
          create: (context) => SurahDetailsViewModel(
            quranRepository: context.read<QuranRepository>(),
            audioRepository: context.read<AudioRepository>(),
            audioControlViewModel: context.read<AudioControlViewModel>(),
          ),
        ),
        ChangeNotifierProvider<DashboardPrayerTimesViewModel>(
          create: (_) => DashboardPrayerTimesViewModel(),
        ),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsViewModel, _) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: AppConstants.appName,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: settingsViewModel.settings.themeMode,
              locale: Locale(settingsViewModel.settings.language.code),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) {
                final responsive = AppResponsive.of(context);
                final mediaQuery = MediaQuery.of(context);
                final maxTextScale = responsive.pick(
                  mobile: responsive.isCompactPhone ? 1.02 : 1.08,
                  tablet: 1.06,
                  desktop: 1.08,
                );
                final clampedMediaQuery = mediaQuery.copyWith(
                  textScaler: mediaQuery.textScaler.clamp(
                    maxScaleFactor: maxTextScale,
                  ),
                );

                final l10n = AppLocalizations.of(context);
                if (l10n != null) {
                  LearnQuranTextLocalizer.seedFromLocalizations(
                    l10n,
                    Localizations.localeOf(context),
                  );
                }

                // Overlay the global audio mini-player at the bottom of the
                // navigator stack. The bar floats above all content and is
                // only visible when audio is playing and the user has
                // navigated away from the source page.
                return Consumer<AudioControlViewModel>(
                  builder: (context, audioControlVm, _) {
                    final showBar = audioControlVm.showMiniPlayer;

                    return MediaQuery(
                      data: clampedMediaQuery,
                      child: Stack(
                        children: [
                          child ?? const SizedBox.shrink(),
                          if (showBar)
                            const Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: GlobalAudioControlBar(),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
              home: const SplashView(),
            ),
          );
        },
      ),
    );
  }
}

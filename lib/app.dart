import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_for_all/presentation/viewmodels/daily_reminders/daily_hadith_viewmodel.dart';
import 'core/constants/app_constants.dart';
import 'core/localization/l10n_extensions.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_ios_scroll_behavior.dart';
import 'data/datasources/local/app_database.dart';
import 'data/datasources/local/prayer_times_local_data_source.dart';
import 'data/datasources/local/prayer_times_preferences_store.dart';
import 'data/datasources/local/prophecies_pack_loader.dart';
import 'data/datasources/remote/quran_api_service.dart';
import 'data/datasources/remote/prayer_times_api_service.dart';
import 'data/repositories/audio_repository_impl.dart';
import 'data/repositories/daily_tracker_repository_impl.dart';
import 'data/repositories/daily_hadith_repository_impl.dart';
import 'data/repositories/islamic_days_repository.dart';
import 'data/repositories/learning_progress_repository_impl.dart';
import 'data/repositories/nurani_quran_repository_impl.dart';
import 'data/repositories/science_in_quran_repository_impl.dart';
import 'data/repositories/prayer_times_repository_impl.dart';
import 'data/repositories/quran_repository_impl.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'data/repositories/tasbeeh_repository_impl.dart';
import 'domain/repositories/audio_repository.dart';
import 'domain/repositories/daily_tracker_repository.dart';
import 'domain/repositories/daily_hadith_repository.dart';
import 'domain/repositories/learning_progress_repository.dart';
import 'domain/repositories/nurani_quran_repository.dart';
import 'domain/repositories/science_in_quran_repository.dart';
import 'domain/repositories/prayer_times_repository.dart';
import 'domain/repositories/quran_repository.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/repositories/tasbeeh_repository.dart';
import 'domain/usecases/add_custom_task_usecase.dart';
import 'domain/usecases/delete_custom_task_usecase.dart';
import 'domain/usecases/get_daily_tasks_usecase.dart';
import 'domain/usecases/get_tracker_section_order_usecase.dart';
import 'domain/usecases/move_custom_task_usecase.dart';
import 'domain/usecases/prayer_times/load_prayer_times_usecase.dart';
import 'domain/usecases/reorder_custom_tasks_usecase.dart';
import 'domain/usecases/save_tracker_section_order_usecase.dart';
import 'domain/usecases/toggle_task_usecase.dart';
import 'presentation/viewmodels/audio_control_viewmodel.dart';
import 'presentation/viewmodels/dashboard/daily_tracker_viewmodel.dart';
import 'presentation/viewmodels/dashboard/tasbeeh_viewmodel.dart';
import 'presentation/viewmodels/dashboard_prayer_times_viewmodel.dart';
import 'presentation/viewmodels/learn_quran_viewmodel.dart';
import 'presentation/viewmodels/islamic_days/islamic_days_viewmodel.dart';
import 'presentation/viewmodels/quran/quran_viewmodel.dart';
import 'presentation/viewmodels/quran/nurani_quran_viewmodel.dart';
import 'presentation/viewmodels/prophecies_viewmodel.dart';
import 'presentation/viewmodels/science_in_quran_viewmodel.dart';
import 'presentation/viewmodels/read_quran/bookmarks_viewmodel.dart';
import 'presentation/viewmodels/read_quran/read_quran_viewmodel.dart';
import 'presentation/viewmodels/read_quran/search_viewmodel.dart';
import 'presentation/viewmodels/read_quran/surah_details_viewmodel.dart';
import 'presentation/viewmodels/settings_viewmodel.dart';
import 'presentation/viewmodels/splash_viewmodel.dart';
import 'presentation/views/splash/splash_view.dart';
import 'presentation/widgets/common/global_audio_control_bar.dart';
import 'presentation/widgets/daily_hadith/shared/daily_hadith_notification_router.dart';
import 'presentation/widgets/islamic_days/shared/islamic_days_notification_router.dart';
import 'services/audio_service.dart';
import 'services/daily_hadith_notification_service.dart';
import 'services/islamic_days/islamic_days_notification_service.dart';
import 'services/notifications/app_notification_coordinator.dart';
import 'services/permission_helper.dart';
import 'services/pronunciation_service.dart';

final appNavigatorKey = GlobalKey<NavigatorState>();

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
        Provider<PrayerTimesLocalDataSource>(
          create: (_) => PrayerTimesLocalDataSource(),
        ),
        Provider<PrayerTimesPreferencesStore>(
          create: (_) => PrayerTimesPreferencesStore(),
        ),
        Provider<QuranApiService>(
          create: (context) => QuranApiService(context.read<http.Client>()),
        ),
        Provider<PrayerTimesApiService>(
          create: (context) =>
              PrayerTimesApiService(context.read<http.Client>()),
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
        Provider<NuraniQuranRepository>(
          create: (context) =>
              NuraniQuranRepositoryImpl(context.read<http.Client>()),
        ),
        Provider<ScienceInQuranRepository>(
          create: (context) =>
              ScienceInQuranRepositoryImpl(context.read<http.Client>()),
        ),
        Provider<PropheciesPackLoader>(create: (_) => PropheciesPackLoader()),
        Provider<PrayerTimesRepository>(
          create: (context) => PrayerTimesRepositoryImpl(
            localDataSource: context.read<PrayerTimesLocalDataSource>(),
            preferencesStore: context.read<PrayerTimesPreferencesStore>(),
            apiService: context.read<PrayerTimesApiService>(),
          ),
        ),
        Provider<LoadPrayerTimesUseCase>(
          create: (context) =>
              LoadPrayerTimesUseCase(context.read<PrayerTimesRepository>()),
        ),
        Provider<LearningProgressRepository>(
          create: (_) => LearningProgressRepositoryImpl(),
        ),
        Provider<AudioRepository>(
          create: (context) =>
              AudioRepositoryImpl(context.read<AudioService>()),
        ),
        Provider<DailyTrackerRepository>(
          create: (_) => DailyTrackerRepositoryImpl(),
        ),
        Provider<DailyHadithRepository>(
          create: (_) => DailyHadithRepositoryImpl(),
        ),
        Provider<IslamicDaysRepository>(create: (_) => IslamicDaysRepository()),
        Provider<AppNotificationCoordinator>(
          create: (_) => AppNotificationCoordinator(),
        ),
        Provider<IslamicDaysNotificationService>(
          create: (context) => IslamicDaysNotificationService(
            context.read<AppNotificationCoordinator>(),
          ),
        ),
        Provider<TasbeehRepository>(create: (_) => TasbeehRepositoryImpl()),
        Provider<DailyHadithNotificationGateway>(
          create: (context) => DailyHadithNotificationService(
            coordinator: context.read<AppNotificationCoordinator>(),
          ),
        ),
        Provider<GetDailyTasksUseCase>(
          create: (context) =>
              GetDailyTasksUseCase(context.read<DailyTrackerRepository>()),
        ),
        Provider<ToggleTaskUseCase>(
          create: (context) =>
              ToggleTaskUseCase(context.read<DailyTrackerRepository>()),
        ),
        Provider<AddCustomTaskUseCase>(
          create: (context) =>
              AddCustomTaskUseCase(context.read<DailyTrackerRepository>()),
        ),
        Provider<DeleteCustomTaskUseCase>(
          create: (context) =>
              DeleteCustomTaskUseCase(context.read<DailyTrackerRepository>()),
        ),
        Provider<ReorderCustomTasksUseCase>(
          create: (context) =>
              ReorderCustomTasksUseCase(context.read<DailyTrackerRepository>()),
        ),
        Provider<GetTrackerSectionOrderUseCase>(
          create: (context) => GetTrackerSectionOrderUseCase(
            context.read<DailyTrackerRepository>(),
          ),
        ),
        Provider<SaveTrackerSectionOrderUseCase>(
          create: (context) => SaveTrackerSectionOrderUseCase(
            context.read<DailyTrackerRepository>(),
          ),
        ),
        Provider<MoveCustomTaskUseCase>(
          create: (context) =>
              MoveCustomTaskUseCase(context.read<DailyTrackerRepository>()),
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
        ChangeNotifierProvider<NuraniQuranViewModel>(
          create: (context) =>
              NuraniQuranViewModel(context.read<NuraniQuranRepository>()),
        ),
        ChangeNotifierProvider<ScienceInQuranViewModel>(
          create: (context) =>
              ScienceInQuranViewModel(context.read<ScienceInQuranRepository>()),
        ),
        ChangeNotifierProvider<PropheciesViewModel>(
          create: (context) =>
              PropheciesViewModel(context.read<PropheciesPackLoader>()),
        ),
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
          create: (context) => DashboardPrayerTimesViewModel(
            loadPrayerTimesUseCase: context.read<LoadPrayerTimesUseCase>(),
          ),
        ),
        ChangeNotifierProvider<IslamicDaysViewModel>(
          create: (context) => IslamicDaysViewModel(
            repository: context.read<IslamicDaysRepository>(),
            notifications: context.read<IslamicDaysNotificationService>(),
          ),
        ),
        ChangeNotifierProvider<DailyTrackerViewModel>(
          create: (context) => DailyTrackerViewModel(
            getDailyTasksUseCase: context.read<GetDailyTasksUseCase>(),
            toggleTaskUseCase: context.read<ToggleTaskUseCase>(),
            addCustomTaskUseCase: context.read<AddCustomTaskUseCase>(),
            deleteCustomTaskUseCase: context.read<DeleteCustomTaskUseCase>(),
            reorderCustomTasksUseCase: context
                .read<ReorderCustomTasksUseCase>(),
            getSectionOrderUseCase: context
                .read<GetTrackerSectionOrderUseCase>(),
            saveSectionOrderUseCase: context
                .read<SaveTrackerSectionOrderUseCase>(),
            moveCustomTaskUseCase: context.read<MoveCustomTaskUseCase>(),
            islamicDays: context.read<IslamicDaysViewModel>(),
          ),
        ),
        ChangeNotifierProvider<DailyHadithViewModel>(
          create: (context) => DailyHadithViewModel(
            repository: context.read<DailyHadithRepository>(),
            notificationGateway: context.read<DailyHadithNotificationGateway>(),
          ),
        ),
        ChangeNotifierProvider<TasbeehViewModel>(
          create: (context) =>
              TasbeehViewModel(repository: context.read<TasbeehRepository>())
                ..load(),
        ),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsViewModel, _) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) => MaterialApp(
              navigatorKey: appNavigatorKey,
              debugShowCheckedModeBanner: false,
              title: AppConstants.appName,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: settingsViewModel.settings.themeMode,
              locale: settingsViewModel.settings.language.locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              scrollBehavior: const AppIosScrollBehavior(),
              builder: (context, child) {
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
                return Selector<AudioControlViewModel, bool>(
                  selector: (_, audioControlVm) =>
                      audioControlVm.showMiniPlayer,
                  builder: (context, showBar, _) {
                    return IslamicDaysNotificationRouter(
                      navigatorKey: appNavigatorKey,
                      locale: settingsViewModel.settings.language.locale
                          .toLanguageTag(),
                      adjustment:
                          settingsViewModel.settings.hijriDateAdjustment,
                      settingsReady: !settingsViewModel.isLoading,
                      child: DailyHadithNotificationRouter(
                        navigatorKey: appNavigatorKey,
                        locale: settingsViewModel.settings.language.locale
                            .toLanguageTag(),
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

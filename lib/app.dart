import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
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
import 'presentation/viewmodels/settings_viewmodel.dart';
import 'presentation/viewmodels/splash_viewmodel.dart';
import 'presentation/views/splash/splash_view.dart';
import 'services/audio_service.dart';

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        home: ChangeNotifierProvider(
          create: (context) =>
              SplashViewModel(quranRepository: context.read<QuranRepository>()),
          child: const SplashView(),
        ),
      ),
    );
  }
}

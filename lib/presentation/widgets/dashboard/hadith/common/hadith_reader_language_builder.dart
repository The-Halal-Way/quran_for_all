import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/enums/app_language.dart';
import '../../../../viewmodels/settings_viewmodel.dart';

typedef HadithReaderLanguageWidgetBuilder =
    Widget Function(
      BuildContext context,
      bool isBangla,
      ValueChanged<bool> onLanguageChanged,
    );

class HadithReaderLanguageBuilder extends StatelessWidget {
  const HadithReaderLanguageBuilder({super.key, required this.builder});

  final HadithReaderLanguageWidgetBuilder builder;

  static bool isBanglaOf(BuildContext context) {
    return context.read<SettingsViewModel>().settings.language ==
        AppLanguage.bangla;
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsViewModel>();
    final isBangla = settings.settings.language == AppLanguage.bangla;

    return builder(context, isBangla, (useBangla) {
      settings.setLanguage(
        useBangla ? AppLanguage.bangla : AppLanguage.english,
      );
    });
  }
}

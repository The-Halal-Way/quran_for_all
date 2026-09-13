import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/app_page_route.dart';
import '../../../../data/models/learn_quran_content.dart';
import '../../../../data/models/surah_model.dart';
import '../../../viewmodels/learn_quran_viewmodel.dart';
import '../../../viewmodels/read_quran/read_quran_viewmodel.dart';
import '../../../viewmodels/read_quran/surah_details_viewmodel.dart';
import '../../../views/quran/learn_quran/learning_quran_detail_view.dart';
import '../../../views/quran/read_quran/surah_details_view.dart';

void pushDashboardPage(BuildContext context, Widget page) {
  Navigator.of(context).push(AppPageRoute<void>(builder: (_) => page));
}

Future<void> openDashboardSurah(
  BuildContext context,
  SurahModel surah,
  int? ayah,
) async {
  unawaited(context.read<SurahDetailsViewModel>().openSurah(surah));
  await Navigator.of(context).push(
    AppPageRoute<void>(
      builder: (_) => SurahDetailsView(surah: surah, initialAyahNumber: ayah),
    ),
  );
  if (context.mounted) {
    await context.read<ReadQuranViewModel>().load(showLoading: false);
  }
}

void openDashboardLesson(BuildContext context, LearnQuranViewModel vm) {
  final lesson = vm.nextLesson;
  final LearnQuranModule? module = lesson == null
      ? (vm.modules.isEmpty ? null : vm.modules.first)
      : vm.moduleForLesson(lesson.id);
  if (module != null) {
    pushDashboardPage(context, LearningQuranDetailView(module: module));
  }
}

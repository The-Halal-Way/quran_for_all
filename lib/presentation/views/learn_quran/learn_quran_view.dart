import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/learn_quran_message_localizer.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/learn_quran_content.dart';
import '../../viewmodels/learn_quran_viewmodel.dart';
import '../../widgets/common/app_gradient_background.dart';
import '../../widgets/common/app_page_scrollbar.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/learn_quran/learn_header_card.dart';
import '../../widgets/learn_quran/learn_module_card.dart';
import '../../widgets/learn_quran/learn_next_lesson_card.dart';
import '../../../core/utils/app_page_route.dart';
import 'learning_module_detail_view.dart';

class LearnQuranView extends StatefulWidget {
  const LearnQuranView({super.key});

  @override
  State<LearnQuranView> createState() => _LearnQuranViewState();
}

class _LearnQuranViewState extends State<LearnQuranView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      unawaited(context.read<LearnQuranViewModel>().initialize());
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LearnQuranViewModel>();
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.learnQuranPageTitle)),
      body: AppGradientBackground(
        child: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: viewModel.initialize,
                child: AppPageScrollbar(
                  builder: (context, controller) => ListView(
                    controller: controller,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.sm + 2, AppSpacing.lg, AppSpacing.lg,
                    ),
                    children: [
                      LearnHeaderCard(
                        overallProgress: viewModel.overallProgress,
                        completedLessons: viewModel.completedLessonCount,
                        totalLessons: viewModel.totalLessonCount,
                        completedModules: viewModel.completedModuleCount,
                        totalModules: viewModel.modules.length,
                        streakDays: viewModel.streakDays,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      LearnNextLessonCard(
                        nextLesson: viewModel.nextLesson,
                        onStart: () => _openNextLesson(context, viewModel),
                      ),
                      if (viewModel.errorMessageKey != null) ...[
                        const SizedBox(height: AppSpacing.sm + 2),
                        Card(
                          color: AppColors.error.withValues(alpha: 0.08),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    localizeLearnQuranMessage(
                                      context,
                                      viewModel.errorMessageKey!,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg - 2),
                      SectionHeader(
                        title: l10n.learnQuranTracksTitle,
                        subtitle: l10n.learnQuranTracksSubtitle,
                      ),
                      const SizedBox(height: AppSpacing.sm + 2),
                      for (final module in viewModel.modules)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
                          child: LearnModuleCard(
                            module: module,
                            completedLessons: viewModel.completedLessonCountFor(
                              module,
                            ),
                            onTap: () => _openModule(context, module),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _openNextLesson(BuildContext context, LearnQuranViewModel viewModel) {
    final lesson = viewModel.nextLesson;
    if (lesson == null) {
      if (viewModel.modules.isNotEmpty) {
        _openModule(context, viewModel.modules.first);
      }
      return;
    }

    final module = viewModel.moduleForLesson(lesson.id);
    if (module == null) {
      return;
    }

    _openModule(context, module);
  }

  void _openModule(BuildContext context, LearnQuranModule module) {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => LearningModuleDetailView(module: module),
      ),
    );
  }
}

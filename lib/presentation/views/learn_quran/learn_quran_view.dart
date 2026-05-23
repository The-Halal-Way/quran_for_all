import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/learn_quran_message_localizer.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/my_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_responsive.dart';
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
      if (!mounted) return;
      unawaited(context.read<LearnQuranViewModel>().initialize());
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LearnQuranViewModel>();
    final l10n = context.l10n;
    final responsive = AppResponsive.of(context);

    return Scaffold(
      body: SafeArea(
        child: AppGradientBackground(
          child: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: viewModel.initialize,
                  child: AppPageScrollbar(
                    builder: (context, controller) => Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: responsive.maxReadingContentWidth,
                        ),
                        child: ListView(
                          controller: controller,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(
                            responsive.padding,
                            AppSpacing.sm + 2,
                            responsive.padding,
                            AppSpacing.lg,
                          ),
                          children: [
                            // banner
                            LearnHeaderCard(
                              overallProgress: viewModel.overallProgress,
                              completedLessons: viewModel.completedLessonCount,
                              totalLessons: viewModel.totalLessonCount,
                              completedModules: viewModel.completedModuleCount,
                              totalModules: viewModel.modules.length,
                              streakDays: viewModel.streakDays,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            // next lesson card
                            LearnNextLessonCard(
                              nextLesson: viewModel.nextLesson,
                              onStart: () => _openNextLesson(context, viewModel),
                            ),
                            if (viewModel.errorMessageKey != null) ...[
                              const SizedBox(height: AppSpacing.sm + 2),
                              Card(
                                color: MyColors.error.withValues(alpha: 0.08),
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
                            // titles for tacks
                            SectionHeader(
                              title: l10n.learnQuranTracksTitle,
                              subtitle: l10n.learnQuranTracksSubtitle,
                            ),
                            const SizedBox(height: AppSpacing.sm + 2),
                            // list of modules
                            for (final module in viewModel.modules)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.sm + 2,
                                ),
                                child: LearnModuleCard(
                                  module: module,
                                  completedLessons: viewModel
                                      .completedLessonCountFor(module),
                                  onTap: () => _openModule(context, module),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
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

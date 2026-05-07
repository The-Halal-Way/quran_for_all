import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/learn_quran_message_localizer.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../data/models/learn_quran_content.dart';
import '../../viewmodels/learn_quran_viewmodel.dart';
import '../../widgets/common/app_page_scrollbar.dart';
import '../../widgets/learn_quran/learn_header_card.dart';
import '../../widgets/learn_quran/learn_module_card.dart';
import '../../widgets/learn_quran/learn_next_lesson_card.dart';
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
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFFCF4), Color(0xFFF2E8D3)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          if (viewModel.isLoading)
            const Center(child: CircularProgressIndicator())
          else
            RefreshIndicator(
              onRefresh: viewModel.initialize,
              child: AppPageScrollbar(
                builder: (context, controller) => ListView(
                  controller: controller,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  children: [
                    LearnHeaderCard(
                      overallProgress: viewModel.overallProgress,
                      completedLessons: viewModel.completedLessonCount,
                      totalLessons: viewModel.totalLessonCount,
                      completedModules: viewModel.completedModuleCount,
                      totalModules: viewModel.modules.length,
                      streakDays: viewModel.streakDays,
                    ),
                    const SizedBox(height: 12),
                    LearnNextLessonCard(
                      nextLesson: viewModel.nextLesson,
                      onStart: () => _openNextLesson(context, viewModel),
                    ),
                    if (viewModel.errorMessageKey != null) ...[
                      const SizedBox(height: 10),
                      Card(
                        color: const Color(0xFFFFEFEA),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline),
                              const SizedBox(width: 8),
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
                    const SizedBox(height: 14),
                    Text(
                      l10n.learnQuranTracksTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.learnQuranTracksSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.72),
                      ),
                    ),
                    const SizedBox(height: 10),
                    for (final module in viewModel.modules)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
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
        ],
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
      MaterialPageRoute<void>(
        builder: (_) => LearningModuleDetailView(module: module),
      ),
    );
  }
}

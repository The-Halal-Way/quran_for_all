import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/playback_source.dart';
import '../../../core/localization/learn_quran_message_localizer.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../data/models/learn_quran_content.dart';
import '../../viewmodels/audio_control_viewmodel.dart';
import '../../viewmodels/learn_quran_viewmodel.dart';
import '../../widgets/common/app_page_scrollbar.dart';
import '../../widgets/learn_quran/audio_assisted/audio_assisted_learning_unit.dart';
import '../../widgets/learn_quran/arabic_letters/arabic_letters_learning_unit.dart';
import '../../widgets/learn_quran/makharij/makharij_learning_unit.dart';
import '../../widgets/learn_quran/pronunciation_basics/pronunciation_basics_learning_unit.dart';
import '../../widgets/learn_quran/short_surah_practice/short_surah_practice_learning_unit.dart';
import '../../widgets/learn_quran/tajweed_rules/tajweed_rules_learning_unit.dart';
import '../../widgets/learn_quran/word_by_word/word_by_word_learning_unit.dart';
import '../../widgets/learn_quran/learn_lesson_tile.dart';
import '../../widgets/learn_quran/learn_module_visuals.dart';

class LearningModuleDetailView extends StatefulWidget {
  const LearningModuleDetailView({super.key, required this.module});

  final LearnQuranModule module;

  @override
  State<LearningModuleDetailView> createState() =>
      _LearningModuleDetailViewState();
}

class _LearningModuleDetailViewState extends State<LearningModuleDetailView> {
  late AudioControlViewModel _audioControlVm;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _audioControlVm = context.read<AudioControlViewModel>();
  }

  @override
  void initState() {
    super.initState();
    // Register as active so the mini-player hides while user is on this page.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _audioControlVm.setActivePage(PlaybackSource.lessonDetail);
      }
    });
  }

  @override
  void dispose() {
    _audioControlVm.clearActivePage(PlaybackSource.lessonDetail);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LearnQuranViewModel>();
    final completedCount = viewModel.completedLessonCountFor(widget.module);
    final progress = widget.module.lessons.isEmpty
        ? 0.0
        : completedCount / widget.module.lessons.length;
    final visuals = LearnModuleVisuals.forModule(widget.module.id);
    final l10n = context.l10n;

    // Seed the Learn Quran text map for the active locale before reading model getters.
    LearnQuranTextLocalizer.seedFromLocalizations(
      l10n,
      Localizations.localeOf(context),
    );

    final moduleTitle = widget.module.title;
    final moduleSubtitle = widget.module.subtitle;
    final moduleDescription = widget.module.description;

    return Scaffold(
      appBar: AppBar(title: Text(moduleTitle)),
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
          AppPageScrollbar(
            builder: (context, controller) => ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      colors: [visuals.startColor, visuals.endColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: visuals.startColor.withValues(alpha: 0.27),
                        blurRadius: 20,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(visuals.icon, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              moduleSubtitle,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        moduleDescription,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.92),
                        ),
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 9,
                          backgroundColor: Colors.white.withValues(alpha: 0.25),
                          color: const Color(0xFFFFDFA9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.learnModuleLessonsCompleted(
                          completedCount,
                          widget.module.lessons.length,
                        ),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                // Render module-specific learning blocks above the lesson list.
                if (widget.module.id == 'arabic_letters') ...[
                  const SizedBox(height: 14),
                  const ArabicLettersLearningUnit(),
                ] else if (widget.module.id == 'pronunciation_basics') ...[
                  const SizedBox(height: 14),
                  const PronunciationBasicsLearningUnit(),
                ] else if (widget.module.id == 'makharij') ...[
                  const SizedBox(height: 14),
                  const MakharijLearningUnit(),
                ] else if (widget.module.id == 'tajweed_rules') ...[
                  const SizedBox(height: 14),
                  const TajweedRulesLearningUnit(),
                ] else if (widget.module.id == 'word_by_word') ...[
                  const SizedBox(height: 14),
                  const WordByWordLearningUnit(),
                ] else if (widget.module.id == 'short_surah_practice') ...[
                  const SizedBox(height: 14),
                  const ShortSurahPracticeLearningUnit(),
                ] else if (widget.module.id == 'audio_assisted') ...[
                  const SizedBox(height: 14),
                  const AudioAssistedLearningUnit(),
                ],
                const SizedBox(height: 14),
                for (final lesson in widget.module.lessons)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: LearnLessonTile(
                      lesson: lesson,
                      isCompleted: viewModel.isLessonCompleted(lesson.id),
                      isAudioPlaying: viewModel.isAudioRunningForLesson(
                        lesson.id,
                      ),
                      onCompletionChanged: (isCompleted) {
                        unawaited(
                          viewModel.setLessonCompletion(
                            lesson: lesson,
                            isCompleted: isCompleted,
                          ),
                        );
                      },
                      onAudioTap: lesson.hasAudioSample
                          ? () => unawaited(
                              _playAudio(context, viewModel, lesson),
                            )
                          : null,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _playAudio(
    BuildContext context,
    LearnQuranViewModel viewModel,
    LearnQuranLesson lesson,
  ) async {
    final message = await viewModel.playLessonAudio(lesson);
    if (!context.mounted || message == null) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(content: Text(localizeLearnQuranMessage(context, message))),
    );
  }
}

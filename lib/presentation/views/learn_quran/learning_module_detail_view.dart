import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/learn_quran_content.dart';
import '../../viewmodels/learn_quran_viewmodel.dart';
import '../../widgets/learn_quran/learn_lesson_tile.dart';
import '../../widgets/learn_quran/learn_module_visuals.dart';

class LearningModuleDetailView extends StatelessWidget {
  const LearningModuleDetailView({super.key, required this.module});

  final LearnQuranModule module;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LearnQuranViewModel>();
    final completedCount = viewModel.completedLessonCountFor(module);
    final progress = module.lessons.isEmpty
        ? 0.0
        : completedCount / module.lessons.length;
    final visuals = LearnModuleVisuals.forModule(module.id);

    return Scaffold(
      appBar: AppBar(title: Text(module.title)),
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
          ListView(
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
                            module.subtitle,
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
                      module.description,
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
                      '$completedCount of ${module.lessons.length} lessons completed',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              for (final lesson in module.lessons)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: LearnLessonTile(
                    lesson: lesson,
                    isCompleted: viewModel.isLessonCompleted(lesson.id),
                    onCompletionChanged: (isCompleted) {
                      unawaited(
                        viewModel.setLessonCompletion(
                          lesson: lesson,
                          isCompleted: isCompleted,
                        ),
                      );
                    },
                    onAudioTap: lesson.hasAudioSample
                        ? () =>
                              unawaited(_playAudio(context, viewModel, lesson))
                        : null,
                  ),
                ),
            ],
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
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

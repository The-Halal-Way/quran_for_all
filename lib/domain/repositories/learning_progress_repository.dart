import '../../data/models/learning_progress.dart';

abstract class LearningProgressRepository {
  Future<LearningProgress> getProgress();

  Future<void> saveProgress(LearningProgress progress);
}

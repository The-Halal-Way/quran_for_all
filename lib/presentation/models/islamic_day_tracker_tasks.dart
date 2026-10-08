import '../../core/enums/task_category.dart';
import '../../data/datasources/local/islamic_days_progress_store.dart';
import '../../data/models/daily_task_model.dart';
import '../../data/models/islamic_days/islamic_day_occurrence.dart';

const islamicDayTaskPrefix = 'islamic_day:';

/// Tasks are derived from today's eligible actions instead of being stored as
/// permanent custom tasks. Restrictions also apply after a Hijri adjustment.
List<DailyTask> islamicDayTrackerTasks(
  List<IslamicDayOccurrence> today,
  IslamicDaysProgressStore progress,
) => [
  for (final occurrence in today)
    if (progress.tracked(occurrence))
      for (final action in occurrence.availableActions)
        DailyTask(
          id: '$islamicDayTaskPrefix${occurrence.actionKey(action)}',
          titleEn: action.text.en,
          titleBn: action.text.bn,
          category: TaskCategory.sunnah,
          isUserCreated: false,
          isOptional: true,
          isCompletedToday: progress.completed(occurrence.actionKey(action)),
        ),
];

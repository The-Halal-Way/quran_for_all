import '../enums/task_category.dart';

/// Keeps saved choices first and appends any categories added by an app update.
List<TaskCategory> completeTaskCategoryOrder(Iterable<TaskCategory> order) =>
    List.unmodifiable({...order, ...TaskCategory.values});

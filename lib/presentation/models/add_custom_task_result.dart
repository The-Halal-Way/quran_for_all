import '../../core/enums/task_category.dart';

class AddCustomTaskResult {
  const AddCustomTaskResult({
    required this.title,
    required this.subtitle,
    required this.isOptional,
    this.category = TaskCategory.custom,
  });

  final String title;
  final String subtitle;
  final bool isOptional;
  final TaskCategory category;
}

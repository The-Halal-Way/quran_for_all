import 'islamic_day.dart';

class IslamicDaysPreferences {
  const IslamicDaysPreferences({
    this.notificationsEnabled = false,
    this.hour = 8,
    this.minute = 0,
    this.preparationEnabled = false,
    this.preparationHour = 20,
    this.preparationMinute = 0,
    this.isOnHajj = false,
    this.categories = const {...IslamicDayCategory.values},
  });

  final bool notificationsEnabled;
  final int hour;
  final int minute;
  final bool preparationEnabled;
  final int preparationHour;
  final int preparationMinute;
  final bool isOnHajj;
  final Set<IslamicDayCategory> categories;

  IslamicDaysPreferences copyWith({
    bool? notificationsEnabled,
    int? hour,
    int? minute,
    bool? preparationEnabled,
    int? preparationHour,
    int? preparationMinute,
    bool? isOnHajj,
    Set<IslamicDayCategory>? categories,
  }) => IslamicDaysPreferences(
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    hour: hour ?? this.hour,
    minute: minute ?? this.minute,
    preparationEnabled: preparationEnabled ?? this.preparationEnabled,
    preparationHour: preparationHour ?? this.preparationHour,
    preparationMinute: preparationMinute ?? this.preparationMinute,
    isOnHajj: isOnHajj ?? this.isOnHajj,
    categories: Set.unmodifiable(categories ?? this.categories),
  );

  factory IslamicDaysPreferences.fromJson(Map<String, dynamic> json) =>
      IslamicDaysPreferences(
        notificationsEnabled: json['enabled'] as bool? ?? false,
        hour: (json['hour'] as int? ?? 8).clamp(0, 23),
        minute: (json['minute'] as int? ?? 0).clamp(0, 59),
        preparationEnabled: json['preparation'] as bool? ?? false,
        preparationHour: (json['preparationHour'] as int? ?? 20).clamp(0, 23),
        preparationMinute: (json['preparationMinute'] as int? ?? 0).clamp(
          0,
          59,
        ),
        isOnHajj: json['onHajj'] as bool? ?? false,
        categories: json['categories'] == null
            ? const {...IslamicDayCategory.values}
            : IslamicDayCategory.values
                  .where(
                    (category) =>
                        (json['categories'] as List).contains(category.name),
                  )
                  .toSet(),
      );

  Map<String, dynamic> toJson() => {
    'enabled': notificationsEnabled,
    'hour': hour,
    'minute': minute,
    'preparation': preparationEnabled,
    'preparationHour': preparationHour,
    'preparationMinute': preparationMinute,
    'onHajj': isOnHajj,
    'categories': categories.map((category) => category.name).toList()..sort(),
  };
}

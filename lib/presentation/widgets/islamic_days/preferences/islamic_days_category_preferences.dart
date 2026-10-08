import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../data/models/islamic_days/islamic_day.dart';
import '../../../models/islamic_day_presenter.dart';
import '../../../viewmodels/islamic_days/islamic_days_viewmodel.dart';
import '../shared/islamic_days_mutation.dart';
import '../shared/islamic_days_section.dart';

class IslamicDaysCategoryPreferences extends StatelessWidget {
  const IslamicDaysCategoryPreferences({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<IslamicDaysViewModel>();
    return IslamicDaysSection(
      title: context.l10n.islamicDaysNotificationCategories,
      icon: Icons.interests_outlined,
      child: Wrap(
        spacing: 8,
        runSpacing: 10,
        children: [
          for (final category in IslamicDayCategory.values)
            FilterChip(
              label: Text(islamicDayCategoryLabel(context.l10n, category)),
              avatar: Icon(islamicDayIcon(category), size: 18),
              selected: vm.preferences.categories.contains(category),
              onSelected: !vm.ready || vm.isLoading || vm.savingPreferences
                  ? null
                  : (selected) {
                      final updated = {...vm.preferences.categories};
                      if (selected) {
                        updated.add(category);
                      } else {
                        updated.remove(category);
                      }
                      saveIslamicDaysChange(
                        context,
                        () => vm.updatePreferences(
                          vm.preferences.copyWith(categories: updated),
                        ),
                      );
                    },
            ),
        ],
      ),
    );
  }
}

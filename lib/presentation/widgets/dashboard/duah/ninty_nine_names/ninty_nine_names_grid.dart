import 'package:flutter/material.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/dashboard/ninety_nine_names.dart'
    as names_model;

import 'ninty_nine_name_card.dart';

class NintyNineNamesGridHeader extends StatelessWidget {
  const NintyNineNamesGridHeader({
    super.key,
    required this.totalNames,
    required this.isDark,
  });

  final int totalNames;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final subColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: MyColors.secondary.withValues(alpha: isDark ? 0.18 : 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.grid_view_rounded,
              color: MyColors.secondary,
              size: 17,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.duahNintyNineNamesGridTitle,
              style: text.titleMedium.copyWith(
                color: titleColor,
                fontWeight: AppTheme.weightExtraBold,
              ),
            ),
          ),
          Text(
            context.l10n.duahNintyNineNamesCount(totalNames),
            style: text.labelMedium.copyWith(
              color: subColor,
              fontWeight: AppTheme.weightBold,
            ),
          ),
        ],
      ),
    );
  }
}

class NintyNineNamesSliverGrid extends StatelessWidget {
  const NintyNineNamesSliverGrid({
    super.key,
    required this.names,
    required this.language,
    required this.isDark,
  });

  final List<names_model.Name> names;
  final AppLanguage language;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.crossAxisExtent;
        final columns = _columnsForWidth(width);
        final mainAxisExtent = language == AppLanguage.bangla ? 205.0 : 194.0;

        return SliverGrid.builder(
          itemCount: names.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: mainAxisExtent,
          ),
          itemBuilder: (context, index) {
            return NintyNineNameCard(
              name: names[index],
              language: language,
              isDark: isDark,
            );
          },
        );
      },
    );
  }

  int _columnsForWidth(double width) {
    if (width >= 920) return 4;
    if (width >= 640) return 3;
    if (width >= 360) return 2;
    return 1;
  }
}

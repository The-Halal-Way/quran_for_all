import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/sunnah_dua/sunnah_dua_models.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/duah/daily_duah/daily_duah_data.dart';

class SunnahDuaViewModel extends ChangeNotifier {
  SunnahDuaFilter _selectedFilter = SunnahDuaFilter.all;

  SunnahDuaFilter get selectedFilter => _selectedFilter;

  void selectFilter(SunnahDuaFilter filter) {
    if (_selectedFilter == filter) {
      return;
    }

    _selectedFilter = filter;
    notifyListeners();
  }

  List<SunnahDuaItem> filteredItems(BuildContext context) {
    final items = allItems(context);
    return switch (_selectedFilter) {
      SunnahDuaFilter.all => items,
      SunnahDuaFilter.sunnah =>
        items.where((item) => item.kind == SunnahDuaKind.sunnah).toList(),
      SunnahDuaFilter.dua =>
        items.where((item) => item.kind == SunnahDuaKind.dua).toList(),
      SunnahDuaFilter.dhikr =>
        items.where((item) => item.kind == SunnahDuaKind.dhikr).toList(),
    };
  }

  int countFor(BuildContext context, SunnahDuaFilter filter) {
    final items = allItems(context);
    return switch (filter) {
      SunnahDuaFilter.all => items.length,
      SunnahDuaFilter.sunnah =>
        items.where((item) => item.kind == SunnahDuaKind.sunnah).length,
      SunnahDuaFilter.dua =>
        items.where((item) => item.kind == SunnahDuaKind.dua).length,
      SunnahDuaFilter.dhikr =>
        items.where((item) => item.kind == SunnahDuaKind.dhikr).length,
    };
  }

  String filterLabel(AppLocalizations l10n, SunnahDuaFilter filter) {
    return switch (filter) {
      SunnahDuaFilter.all => l10n.sunnahDuaFilterAll,
      SunnahDuaFilter.sunnah => l10n.sunnahDuaFilterSunnah,
      SunnahDuaFilter.dua => l10n.sunnahDuaFilterDua,
      SunnahDuaFilter.dhikr => l10n.sunnahDuaFilterDhikr,
    };
  }

  IconData filterIcon(SunnahDuaFilter filter) {
    return switch (filter) {
      SunnahDuaFilter.all => Icons.grid_view_rounded,
      SunnahDuaFilter.sunnah => Icons.auto_awesome_rounded,
      SunnahDuaFilter.dua => Icons.volunteer_activism_rounded,
      SunnahDuaFilter.dhikr => Icons.favorite_rounded,
    };
  }

  String kindLabel(AppLocalizations l10n, SunnahDuaKind kind) {
    return switch (kind) {
      SunnahDuaKind.sunnah => l10n.sunnahDuaKindSunnah,
      SunnahDuaKind.dua => l10n.sunnahDuaKindDua,
      SunnahDuaKind.dhikr => l10n.sunnahDuaKindDhikr,
    };
  }

  List<SunnahDuaItem> allItems(BuildContext context) {
    final l10n = context.l10n;

    // Sunnah cards describe the whole practice. A related du'a is embedded
    // inside the card/detail so the same du'a is not repeated as a second item.
    return [
      _sunnahItem(
        context,
        id: 'eating_sunnahs',
        dailyDuaTitle: 'Before eating',
        icon: Icons.restaurant_rounded,
        accent: MyColors.secondary,
        gradientColors: const [MyColors.secondary, MyColors.secondaryLight],
        title: l10n.sunnahDuaEatingSunnahsTitle,
        subtitle: l10n.sunnahDuaEatingSunnahsSubtitle,
        pointsRaw: l10n.sunnahDuaEatingSunnahsPointsRaw,
        practice: l10n.sunnahDuaEatingSunnahsPractice,
        isFeatured: true,
      ),
      _sunnahItem(
        context,
        id: 'miswak',
        dailyDuaTitle: null,
        icon: Icons.brush_rounded,
        accent: MyColors.tertiary,
        gradientColors: const [MyColors.tertiary, MyColors.primaryLight],
        title: l10n.sunnahDuaMiswakTitle,
        subtitle: l10n.sunnahDuaMiswakSubtitle,
        pointsRaw: l10n.sunnahDuaMiswakPointsRaw,
        arabic: l10n.sunnahDuaMiswakArabic,
        pronunciation: l10n.sunnahDuaMiswakPronunciation,
        translation: l10n.sunnahDuaMiswakTranslation,
        practice: l10n.sunnahDuaMiswakPractice,
        source: l10n.sunnahDuaMiswakSource,
        isFeatured: true,
      ),
      _sunnahItem(
        context,
        id: 'sleeping_sunnahs',
        dailyDuaTitle: 'Before sleeping',
        icon: Icons.bedtime_rounded,
        accent: MyColors.info,
        gradientColors: const [MyColors.info, MyColors.primaryLight],
        title: l10n.sunnahDuaSleepingSunnahsTitle,
        subtitle: l10n.sunnahDuaSleepingSunnahsSubtitle,
        pointsRaw: l10n.sunnahDuaSleepingSunnahsPointsRaw,
        practice: l10n.sunnahDuaSleepingSunnahsPractice,
      ),
      _sunnahItem(
        context,
        id: 'home_sunnahs',
        dailyDuaTitle: 'Leaving home',
        icon: Icons.home_rounded,
        accent: MyColors.primaryLight,
        gradientColors: const [MyColors.primaryLight, MyColors.tertiary],
        title: l10n.sunnahDuaHomeSunnahsTitle,
        subtitle: l10n.sunnahDuaHomeSunnahsSubtitle,
        pointsRaw: l10n.sunnahDuaHomeSunnahsPointsRaw,
        practice: l10n.sunnahDuaHomeSunnahsPractice,
      ),
      _sunnahItem(
        context,
        id: 'wudu_sunnahs',
        dailyDuaTitle: 'After wudū\'',
        icon: Icons.water_drop_rounded,
        accent: MyColors.tertiaryDark,
        gradientColors: const [MyColors.tertiaryDark, MyColors.tertiary],
        title: l10n.sunnahDuaWuduSunnahsTitle,
        subtitle: l10n.sunnahDuaWuduSunnahsSubtitle,
        pointsRaw: l10n.sunnahDuaWuduSunnahsPointsRaw,
        practice: l10n.sunnahDuaWuduSunnahsPractice,
      ),
      _sunnahItem(
        context,
        id: 'masjid_sunnahs',
        dailyDuaTitle: 'Entering masjid',
        icon: Icons.mosque_rounded,
        accent: MyColors.primaryLight,
        gradientColors: const [MyColors.primary, MyColors.primaryLight],
        title: l10n.sunnahDuaMasjidSunnahsTitle,
        subtitle: l10n.sunnahDuaMasjidSunnahsSubtitle,
        pointsRaw: l10n.sunnahDuaMasjidSunnahsPointsRaw,
        practice: l10n.sunnahDuaMasjidSunnahsPractice,
      ),
      _sunnahItem(
        context,
        id: 'sneezing_sunnah',
        dailyDuaTitle: 'When sneezing',
        icon: Icons.air_rounded,
        accent: MyColors.secondary,
        gradientColors: const [MyColors.secondary, MyColors.tertiary],
        title: l10n.sunnahDuaSneezingSunnahTitle,
        subtitle: l10n.sunnahDuaSneezingSunnahSubtitle,
        pointsRaw: l10n.sunnahDuaSneezingSunnahPointsRaw,
        practice: l10n.sunnahDuaSneezingSunnahPractice,
      ),
      _dailyItem(
        context,
        id: 'seeking_forgiveness',
        title: 'Seeking forgiveness',
        kind: SunnahDuaKind.dhikr,
        icon: Icons.favorite_rounded,
        accent: MyColors.secondaryLight,
        gradientColors: const [MyColors.secondaryDark, MyColors.secondaryLight],
        subtitle: l10n.sunnahDuaSeekingForgivenessSubtitle,
        practice: l10n.sunnahDuaSeekingForgivenessPractice,
      ),
      _dailyItem(
        context,
        id: 'difficulty',
        title: 'When worried or in difficulty',
        kind: SunnahDuaKind.dua,
        icon: Icons.shield_rounded,
        accent: MyColors.success,
        gradientColors: const [MyColors.tertiaryDark, MyColors.success],
        subtitle: l10n.sunnahDuaDifficultySubtitle,
        practice: l10n.sunnahDuaDifficultyPractice,
      ),
    ];
  }

  SunnahDuaItem _sunnahItem(
    BuildContext context, {
    required String id,
    required String? dailyDuaTitle,
    required IconData icon,
    required Color accent,
    required List<Color> gradientColors,
    required String title,
    required String subtitle,
    required String pointsRaw,
    required String practice,
    String arabic = '',
    String pronunciation = '',
    String translation = '',
    String source = '',
    bool isFeatured = false,
  }) {
    final duah = dailyDuaTitle == null ? null : _findDuah(dailyDuaTitle);

    return SunnahDuaItem(
      id: id,
      kind: SunnahDuaKind.sunnah,
      icon: icon,
      accent: accent,
      gradientColors: gradientColors,
      title: title,
      subtitle: subtitle,
      arabic: duah?.arabic ?? arabic,
      pronunciation: duah?.localizedPronunciation(context) ?? pronunciation,
      translation: duah?.localizedTranslation(context) ?? translation,
      practice: practice,
      source: source.isEmpty ? context.l10n.sunnahDuaSourceDailySunnah : source,
      sunnahPoints: _splitPoints(pointsRaw),
      relatedDuaTitle: duah?.localizedTitle(context) ?? '',
      isFeatured: isFeatured,
    );
  }

  SunnahDuaItem _dailyItem(
    BuildContext context, {
    required String id,
    required String title,
    required SunnahDuaKind kind,
    required IconData icon,
    required Color accent,
    required List<Color> gradientColors,
    required String subtitle,
    required String practice,
  }) {
    final duah = _findDuah(title);

    return SunnahDuaItem(
      id: id,
      kind: kind,
      icon: icon,
      accent: accent,
      gradientColors: gradientColors,
      title: duah.localizedTitle(context),
      subtitle: subtitle,
      arabic: duah.arabic,
      pronunciation: duah.localizedPronunciation(context),
      translation: duah.localizedTranslation(context),
      practice: practice,
      source: context.l10n.sunnahDuaSourceDailyDua,
    );
  }

  List<String> _splitPoints(String raw) {
    return raw
        .split('||')
        .map((point) => point.trim())
        .where((point) => point.isNotEmpty)
        .toList(growable: false);
  }

  DuahItem _findDuah(String title) {
    for (final category in DuahData.advanced) {
      for (final item in category.items) {
        if (item.title == title) {
          return item;
        }

        for (final subItem in item.subItems) {
          if (subItem.title == title) {
            return subItem;
          }
        }
      }
    }

    // A fallback keeps the UI resilient if the shared data changes later.
    return DuahItem(
      title: title,
      arabic: '',
      pronunciation: title,
      translation: title,
    );
  }
}

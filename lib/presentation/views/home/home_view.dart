import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/my_colors.dart';
import '../../../core/utils/app_responsive.dart';
import '../dashboard/dashboard_view.dart';
import '../prayer/prayer_view.dart';
import '../quran/quran_view.dart';
import '../settings/settings_view.dart';
import '../sunnah_dua/sunnah_dua_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final List<Widget> _sections = const [
    DashboardView(),
    PrayerView(),
    QuranView(),
    SunnahDuaView(),
    SettingsView(embedded: true),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = AppResponsive.of(context);
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconSize = responsive.isTablet ? 22.0 : 24.0;
    final active = colors.primary;
    final inactive = colors.onSurfaceVariant.withValues(alpha: 0.58);

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _sections),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: EdgeInsets.fromLTRB(
          responsive.isTablet ? AppSpacing.xxl : AppSpacing.md,
          AppSpacing.xs,
          responsive.isTablet ? AppSpacing.xxl : AppSpacing.md,
          AppSpacing.sm,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: colors.outline.withValues(alpha: isDark ? 0.42 : 0.3),
              width: 0.7,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: isDark ? 0.28 : 0.13),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: CupertinoTabBar(
              currentIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
              height: responsive.isTablet ? 60 : 58,
              iconSize: iconSize,
              activeColor: active,
              inactiveColor: inactive,
              backgroundColor: (isDark ? colors.surfaceContainer : Colors.white)
                  .withValues(alpha: 0.96),
              border: const Border(),
              items: [
                BottomNavigationBarItem(
                  icon: _PremiumTabIcon(
                    icon: CupertinoIcons.house,
                    color: inactive,
                  ),
                  activeIcon: const _PremiumTabIcon(
                    icon: CupertinoIcons.house_fill,
                    selected: true,
                  ),
                  label: l10n.homeDashboardTab,
                ),
                BottomNavigationBarItem(
                  icon: _PremiumTabIcon(
                    icon: Icons.mosque_outlined,
                    color: inactive,
                  ),
                  activeIcon: const _PremiumTabIcon(
                    icon: Icons.mosque_rounded,
                    selected: true,
                  ),
                  label: l10n.homePrayerTab,
                ),
                BottomNavigationBarItem(
                  icon: _PremiumTabIcon(
                    icon: CupertinoIcons.book,
                    color: inactive,
                  ),
                  activeIcon: const _PremiumTabIcon(
                    icon: CupertinoIcons.book_fill,
                    selected: true,
                  ),
                  label: l10n.homeQuranTab,
                ),
                BottomNavigationBarItem(
                  icon: _PremiumTabIcon(
                    icon: CupertinoIcons.sparkles,
                    color: inactive,
                  ),
                  activeIcon: const _PremiumTabIcon(
                    icon: CupertinoIcons.sparkles,
                    selected: true,
                  ),
                  label: l10n.homeSunnahDuaTab,
                ),
                BottomNavigationBarItem(
                  icon: _PremiumTabIcon(
                    icon: CupertinoIcons.gear,
                    color: inactive,
                  ),
                  activeIcon: const _PremiumTabIcon(
                    icon: CupertinoIcons.gear_solid,
                    selected: true,
                  ),
                  label: l10n.settingsTitle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumTabIcon extends StatelessWidget {
  const _PremiumTabIcon({
    required this.icon,
    this.color,
    this.selected = false,
  });

  final IconData icon;
  final Color? color;
  final bool selected;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 220),
    curve: Curves.easeOutCubic,
    width: selected ? 39 : 32,
    height: 28,
    decoration: BoxDecoration(
      gradient: selected
          ? LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                MyColors.primaryLight,
              ],
            )
          : null,
      borderRadius: BorderRadius.circular(AppRadius.full),
      boxShadow: selected
          ? [
              BoxShadow(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.22),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ]
          : null,
    ),
    alignment: Alignment.center,
    child: Icon(
      icon,
      size: selected ? 18 : 21,
      color: selected ? Colors.white : color,
    ),
  );
}

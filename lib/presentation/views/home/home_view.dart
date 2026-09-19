import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/my_icons.dart';
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
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        height: responsive.isTablet ? 56 : 52,
        iconSize: iconSize,
        activeColor: active,
        inactiveColor: inactive,
        backgroundColor: (isDark ? colors.surface : Colors.white).withValues(
          alpha: 0.9,
        ),
        border: Border(
          top: BorderSide(
            color: colors.outline.withValues(alpha: isDark ? 0.3 : 0.2),
            width: 0.5,
          ),
        ),
        items: [
          BottomNavigationBarItem(
            icon: _AssetTabIcon(
              asset: MyIcons.homeIcon,
              color: inactive,
              size: iconSize,
            ),
            activeIcon: _AssetTabIcon(
              asset: MyIcons.homeIconFill,
              color: active,
              size: iconSize,
            ),
            label: l10n.homeDashboardTab,
          ),
          BottomNavigationBarItem(
            icon: _AssetTabIcon(
              asset: MyIcons.prayerIcon,
              color: inactive,
              size: iconSize,
            ),
            activeIcon: _AssetTabIcon(
              asset: MyIcons.prayerIconFill,
              color: active,
              size: iconSize,
            ),
            label: l10n.homePrayerTab,
          ),
          BottomNavigationBarItem(
            icon: _AssetTabIcon(
              asset: MyIcons.quranViewIcon,
              color: inactive,
              size: iconSize,
            ),
            activeIcon: _AssetTabIcon(
              asset: MyIcons.quranViewIconFill,
              color: active,
              size: iconSize,
            ),
            label: l10n.homeQuranTab,
          ),
          BottomNavigationBarItem(
            icon: _AssetTabIcon(
              asset: MyIcons.duaIcon,
              color: inactive,
              size: iconSize,
            ),
            activeIcon: _AssetTabIcon(
              asset: MyIcons.duaIconFill,
              color: active,
              size: iconSize,
            ),
            label: l10n.homeSunnahDuaTab,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.gear_alt, color: inactive),
            activeIcon: Icon(CupertinoIcons.gear_solid, color: active),
            label: l10n.settingsTitle,
          ),
        ],
      ),
    );
  }
}

class _AssetTabIcon extends StatelessWidget {
  const _AssetTabIcon({
    required this.asset,
    required this.color,
    required this.size,
  });

  final String asset;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Image.asset(
    asset,
    width: size,
    height: size,
    color: color,
    colorBlendMode: BlendMode.srcIn,
    filterQuality: FilterQuality.high,
  );
}

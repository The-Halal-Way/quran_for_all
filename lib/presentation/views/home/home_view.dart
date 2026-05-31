import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/my_icons.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/core/theme/my_images.dart';
import 'package:quran_for_all/presentation/views/dashboard/dashboard_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/prayer_view.dart';
import 'package:quran_for_all/presentation/views/quran/quran_view.dart';
import 'package:quran_for_all/presentation/views/sunnah_dua/sunnah_dua_view.dart';
import 'package:lottie/lottie.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/utils/app_responsive.dart';
import '../settings/settings_view.dart';

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
    final navIconSize = responsive.isDesktop
        ? 22.0
        : responsive.isTablet
        ? 21.0
        : 24.0;
    final navHeight = responsive.isDesktop
        ? 74.0
        : responsive.isTablet
        ? 76.0
        : 78.0;

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _sections),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
        ),
        child: NavigationBar(
          height: navHeight,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Image.asset(
                MyIcons.homeIcon,
                width: navIconSize,
                height: navIconSize,
              ),
              selectedIcon: Image.asset(
                MyIcons.homeIconFill,
                width: navIconSize,
                height: navIconSize,
              ),
              label: l10n.homeDashboardTab,
            ),
            NavigationDestination(
              icon: Image.asset(
                MyIcons.prayerIcon,
                width: navIconSize,
                height: navIconSize,
              ),
              selectedIcon: Image.asset(
                MyIcons.prayerIconFill,
                width: navIconSize,
                height: navIconSize,
              ),
              label: l10n.homePrayerTab,
            ),
            NavigationDestination(
              icon: _QuranNavIcon(size: navIconSize, isSelected: false),
              selectedIcon: _QuranNavIcon(size: navIconSize, isSelected: true),
              label: l10n.homeQuranTab,
            ),
            NavigationDestination(
              icon: Image.asset(
                MyIcons.duaIcon,
                width: navIconSize,
                height: navIconSize,
              ),
              selectedIcon: Image.asset(
                MyIcons.duaIconFill,
                width: navIconSize,
                height: navIconSize,
              ),
              label: l10n.homeSunnahDuaTab,
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined, size: navIconSize),
              selectedIcon: Image.asset(
                MyIcons.settingsIcon,
                width: navIconSize,
                height: navIconSize,
              ),
              label: l10n.settingsTitle,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuranNavIcon extends StatelessWidget {
  const _QuranNavIcon({required this.size, required this.isSelected});

  final double size;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    if (!isSelected) {
      return Container(
        width: size + 10,
        height: size + 10,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: MyColors.primaryLight.withValues(alpha: 0.08),
          shape: BoxShape.circle,
          border: Border.all(
            color: MyColors.primaryLight.withValues(alpha: 0.22),
          ),
        ),
        child: Image.asset(MyIcons.quranViewIcon, width: size, height: size),
      );
    }

    return Container(
      width: size + 24,
      height: size + 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            MyColors.primaryLight,
            MyColors.secondary,
            MyColors.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.34),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.secondary.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
          BoxShadow(
            color: MyColors.tertiary.withValues(alpha: 0.20),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SizedBox(
        width: size + 10,
        height: size + 10,
        child: Lottie.asset(
          MyImages.quranAnimated,
          repeat: true,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/my_icons.dart';
import 'package:quran_for_all/presentation/views/dashboard/dashboard_view.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/utils/app_responsive.dart';
import '../learn_quran/learn_quran_view.dart';
import '../read_quran/read_quran_view.dart';
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
    ReadQuranView(),
    LearnQuranView(),
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
        ? 68.0
        : responsive.isTablet
        ? 70.0
        : 72.0;

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
                MyIcons.quranViewIcon,
                width: navIconSize,
                height: navIconSize,
              ),
              selectedIcon: Image.asset(
                MyIcons.quranViewIconFill,
                width: navIconSize,
                height: navIconSize,
              ),
              label: "Dashboard",
            ),
            NavigationDestination(
              icon: Image.asset(
                MyIcons.quranViewIcon,
                width: navIconSize,
                height: navIconSize,
              ),
              selectedIcon: Image.asset(
                MyIcons.quranViewIconFill,
                width: navIconSize,
                height: navIconSize,
              ),
              label: l10n.homeReadQuranTab,
            ),
            NavigationDestination(
              icon: Image.asset(
                MyIcons.learnIconUnselected,
                width: navIconSize,
                height: navIconSize,
              ),
              selectedIcon: Image.asset(
                MyIcons.learnIcon,
                width: navIconSize,
                height: navIconSize,
              ),
              label: l10n.homeLearnQuranTab,
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined, size: navIconSize),
              selectedIcon: Image.asset(
                MyIcons.settingsIcon,
                width: navIconSize,
                height: navIconSize,
              ),
              label: context.readQuranText('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

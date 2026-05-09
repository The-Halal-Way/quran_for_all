import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extensions.dart';
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
    ReadQuranView(),
    LearnQuranView(),
    SettingsView(embedded: true),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _sections),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.menu_book_rounded),
              selectedIcon: const Icon(Icons.menu_book),
              label: l10n.homeReadQuranTab,
            ),
            NavigationDestination(
              icon: const Icon(Icons.school_outlined),
              selectedIcon: const Icon(Icons.school_rounded),
              label: l10n.homeLearnQuranTab,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings_rounded),
              label: context.readQuranText('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

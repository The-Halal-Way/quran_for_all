import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part '../../../widgets/dashobard/duah/daily_duah/daily_duah_data.dart';
part '../../../widgets/dashobard/duah/daily_duah/daily_duah_widgets.dart';

class DailyDuahView extends StatefulWidget {
  const DailyDuahView({super.key});
  @override
  State<DailyDuahView> createState() => _DailyDuahViewState();
}

class _DailyDuahViewState extends State<DailyDuahView>
    with SingleTickerProviderStateMixin {
  DuahLevel _selectedLevel = DuahLevel.beginner;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _switchLevel(DuahLevel level) {
    if (_selectedLevel == level) return;
    _fadeCtrl.reverse().then((_) {
      setState(() => _selectedLevel = level);
      _fadeCtrl.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final categories = DuahData.forLevel(_selectedLevel);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _DuahAppBar(
            isDark: isDark,
            selectedLevel: _selectedLevel,
            onLevelChanged: _switchLevel,
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            sliver: SliverFadeTransition(
              opacity: _fadeAnim,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index == 0) {
                    return _LevelBanner(level: _selectedLevel, isDark: isDark);
                  }
                  final cat = categories[index - 1];
                  return _CategorySection(
                    category: cat,
                    isDark: isDark,
                    isLast: index == categories.length,
                  );
                }, childCount: categories.length + 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

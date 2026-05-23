import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/presentation/widgets/dashobard/duah/daily_duah/daily_duah_data.dart';
import 'package:quran_for_all/presentation/widgets/dashobard/duah/daily_duah/daily_duah_widgets.dart';

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
    final responsive = AppResponsive.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = responsive.maxReadingContentWidth;
          final horizontal = constraints.maxWidth > maxWidth
              ? (constraints.maxWidth - maxWidth) / 2
              : responsive.padding;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              DuahAppBar(
                isDark: isDark,
                selectedLevel: _selectedLevel,
                onLevelChanged: _switchLevel,
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(horizontal, 12.h, horizontal, 0),
                sliver: SliverFadeTransition(
                  opacity: _fadeAnim,
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index == 0) {
                        return LevelBanner(
                          level: _selectedLevel,
                          isDark: isDark,
                        );
                      }
                      final cat = categories[index - 1];
                      return CategorySection(
                        category: cat,
                        isDark: isDark,
                        isLast: index == categories.length,
                      );
                    }, childCount: categories.length + 1),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/duah/powerful_duah/powerful_duah_data.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/duah/powerful_duah/powerful_duah_widgets.dart';

class PowerfulDuahView extends StatefulWidget {
  const PowerfulDuahView({super.key});

  @override
  State<PowerfulDuahView> createState() => _PowerfulDuahViewState();
}

class _PowerfulDuahViewState extends State<PowerfulDuahView>
    with SingleTickerProviderStateMixin {
  DuahSituation _selected = DuahSituation.all;
  bool _featuredOnly = false;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _switch(DuahSituation s) {
    if (_selected == s) return;
    _fadeCtrl.reverse().then((_) {
      setState(() => _selected = s);
      _fadeCtrl.forward();
    });
  }

  List<PowerfulDuah> get _filtered {
    var list = PowerfulDuahData.filtered(_selected);
    if (_featuredOnly) list = list.where((d) => d.isFeatured).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final horizontal = 12.h;
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // appbar
              PowerfulAppBar(isDark: isDark),
              // note banner
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: horizontal),
                sliver: SliverToBoxAdapter(child: NoteBanner(isDark: isDark)),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: horizontal),
                sliver: SliverToBoxAdapter(
                  child: FilterRow(
                    selected: _selected,
                    featuredOnly: _featuredOnly,
                    isDark: isDark,
                    onSituationChanged: _switch,
                    onFeaturedToggled: () =>
                        setState(() => _featuredOnly = !_featuredOnly),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: horizontal),
                sliver: SliverToBoxAdapter(
                  child: CountBar(
                    count: _filtered.length,
                    total: PowerfulDuahData.all.length,
                    situation: _selected,
                    isDark: isDark,
                  ),
                ),
              ),
              SliverFadeTransition(
                opacity: _fadeAnim,
                sliver: SliverPadding(
                  padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 40),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => PowerfulDuahCard(
                        duah: _filtered[i],
                        isDark: isDark,
                        situationColor: _selected.color,
                      ),
                      childCount: _filtered.length,
                    ),
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

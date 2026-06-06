import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/presentation/viewmodels/duah/ninty_nine_names_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/common/app_page_scrollbar.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/duah/ninty_nine_names/ninty_nine_names_widgets.dart';

class DuahNintyNineView extends StatelessWidget {
  const DuahNintyNineView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NintyNineNamesViewModel>(
      create: (_) => NintyNineNamesViewModel()..load(),
      child: const _DuahNintyNineBody(),
    );
  }
}

class _DuahNintyNineBody extends StatelessWidget {
  const _DuahNintyNineBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NintyNineNamesViewModel>();
    final language = context.watch<SettingsViewModel>().settings.language;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final responsive = AppResponsive.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _NamesBackgroundPainter(isDark)),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = responsive.maxReadingContentWidth;
              final horizontal = constraints.maxWidth > maxWidth
                  ? (constraints.maxWidth - maxWidth) / 2
                  : responsive.padding;

              return AppPageScrollbar(
                builder: (context, controller) => CustomScrollView(
                  controller: controller,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    const NintyNineNamesAppBar(),
                    if (vm.isLoading && !vm.hasData)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: NintyNineNamesLoadingState(),
                      )
                    else if (!vm.hasData)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: NintyNineNamesErrorState(
                          isDark: isDark,
                          onRetry: vm.reload,
                        ),
                      )
                    else
                      ..._contentSlivers(
                        context: context,
                        vm: vm,
                        language: language,
                        isDark: isDark,
                        horizontal: horizontal,
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _contentSlivers({
    required BuildContext context,
    required NintyNineNamesViewModel vm,
    required AppLanguage language,
    required bool isDark,
    required double horizontal,
  }) {
    final data = vm.data!;

    return [
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: horizontal),
        sliver: SliverToBoxAdapter(
          child: NintyNineNamesHero(
            data: data,
            language: language,
            categoryCount: vm.categories.length,
            isDark: isDark,
          ),
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: horizontal),
        sliver: SliverToBoxAdapter(
          child: NintyNineNamesInsightCard(
            icon: Icons.favorite_rounded,
            title: context.l10n.duahNintyNineBenefitTitle,
            body: data.metadata.benefitFor(language),
            accent: MyColors.secondary,
            isDark: isDark,
          ),
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: horizontal),
        sliver: SliverToBoxAdapter(
          child: NintyNineNamesInsightCard(
            icon: Icons.verified_rounded,
            title: context.l10n.duahNintyNineConclusionTitle,
            body: data.metadata.conclusionFor(language),
            accent: MyColors.tertiary,
            isDark: isDark,
          ),
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: horizontal),
        sliver: SliverToBoxAdapter(
          child: NintyNineNamesGridHeader(
            totalNames: data.names.length,
            isDark: isDark,
          ),
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 36),
        sliver: NintyNineNamesSliverGrid(
          names: data.names,
          language: language,
          isDark: isDark,
        ),
      ),
    ];
  }
}

class _NamesBackgroundPainter extends CustomPainter {
  const _NamesBackgroundPainter(this.isDark);

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? MyColors.tertiaryLight : MyColors.primaryLight)
          .withValues(alpha: isDark ? 0.045 : 0.035)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    const step = 58.0;
    for (double x = -step; x < size.width + step; x += step) {
      for (double y = -step; y < size.height + step; y += step) {
        final path = Path()
          ..moveTo(x + step / 2, y + 6)
          ..lineTo(x + step - 6, y + step / 2)
          ..lineTo(x + step / 2, y + step - 6)
          ..lineTo(x + 6, y + step / 2)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NamesBackgroundPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}

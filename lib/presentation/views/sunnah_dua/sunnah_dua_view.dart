import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_gradients.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/data/models/dashboard/dashboard_action_item.dart';
import 'package:quran_for_all/data/models/sunnah_dua/sunnah_dua_models.dart';
import 'package:quran_for_all/presentation/viewmodels/sunnah_dua_viewmodel.dart';
import 'package:quran_for_all/presentation/views/sunnah_dua/duah/daily_duah_view.dart';
import 'package:quran_for_all/presentation/views/sunnah_dua/duah/duah_ninty_nine_view.dart';
import 'package:quran_for_all/presentation/views/sunnah_dua/duah/powerful_duah_view.dart';
import 'package:quran_for_all/presentation/widgets/common/app_page_scrollbar.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/sunnah_dua_widgets.dart';

class SunnahDuaView extends StatefulWidget {
  const SunnahDuaView({super.key, this.showBackButton = false});
  final bool showBackButton;
  @override
  State<SunnahDuaView> createState() => _SunnahDuaViewState();
}

class _SunnahDuaViewState extends State<SunnahDuaView> {
  final SunnahDuaViewModel _viewModel = SunnahDuaViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        final items = _viewModel.filteredItems(context);

        return Scaffold(
          body: SafeArea(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: isDark
                    ? AppGradients.darkPageBg
                    : AppGradients.pageBg,
              ),
              child: AppPageScrollbar(
                builder: (context, controller) => SingleChildScrollView(
                  controller: controller,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.fromLTRB(
                    responsive.padding,
                    AppSpacing.md,
                    responsive.padding,
                    AppSpacing.huge,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: responsive.maxReadingContentWidth,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // banner
                          SunnahDuaHero(
                            totalCount: _viewModel.countFor(
                              context,
                              SunnahDuaFilter.all,
                            ),
                            sunnahCount: _viewModel.countFor(
                              context,
                              SunnahDuaFilter.sunnah,
                            ),
                            duaCount: _viewModel.countFor(
                              context,
                              SunnahDuaFilter.dua,
                            ),
                            onBack: widget.showBackButton
                                ? () => Navigator.maybePop(context)
                                : null,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          // daily dua, powerful dua, ninety nine names shortcuts
                          _DuahShortcutSection(
                            items: _buildDuahShortcutItems(context),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          SunnahDuaFilterBar(
                            viewModel: _viewModel,
                            selectedFilter: _viewModel.selectedFilter,
                            countBuilder: (filter) =>
                                _viewModel.countFor(context, filter),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _GridHeader(count: items.length),
                          const SizedBox(height: AppSpacing.md),
                          SunnahDuaGrid(
                            items: items,
                            kindLabelBuilder: (kind) =>
                                _viewModel.kindLabel(context.l10n, kind),
                            onItemTap: _showDetails,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<DashboardActionItem> _buildDuahShortcutItems(BuildContext context) {
    return [
      DashboardActionItem(
        icon: Icons.wb_twilight_rounded,
        label: context.l10n.dashboardActionDailyDua,
        sublabel: context.l10n.dashboardActionDailyDuaSub,
        color: MyColors.tertiary,
        onTap: () => _push(const DailyDuahView()),
      ),
      DashboardActionItem(
        icon: Icons.bolt_rounded,
        label: context.l10n.dashboardActionPowerfulDua,
        sublabel: context.l10n.dashboardActionPowerfulDuaSub,
        color: MyColors.secondary,
        onTap: () => _push(const PowerfulDuahView()),
      ),
      DashboardActionItem(
        icon: Icons.diamond_rounded,
        label: context.l10n.dashboardActionNintyNineNames,
        sublabel: context.l10n.dashboardActionNintyNineNamesSub,
        color: MyColors.primaryLight,
        onTap: () => _push(const DuahNintyNineView()),
      ),
    ];
  }

  void _push(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _showDetails(SunnahDuaItem item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      barrierColor: MyColors.primaryDark.withValues(alpha: 0.58),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          minChildSize: 0.38,
          maxChildSize: 0.92,
          builder: (context, controller) {
            return SunnahDuaDetailSheet(
              controller: controller,
              item: item,
              kindLabel: _viewModel.kindLabel(sheetContext.l10n, item.kind),
            );
          },
        );
      },
    );
  }
}

class _DuahShortcutSection extends StatelessWidget {
  const _DuahShortcutSection({required this.items});

  final List<DashboardActionItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: context.l10n.dashboardSectionDua,
          icon: Icons.auto_awesome_rounded,
          color: MyColors.tertiary,
        ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 720) {
              return _MobileDuahShortcutRows(items: items);
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                mainAxisExtent: 118,
              ),
              itemBuilder: (context, index) {
                return _DuahShortcutCard(item: items[index]);
              },
            );
          },
        ),
      ],
    );
  }
}

class _MobileDuahShortcutRows extends StatelessWidget {
  const _MobileDuahShortcutRows({required this.items});

  final List<DashboardActionItem> items;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    for (var start = 0; start < items.length; start += 2) {
      final rowItems = items.skip(start).take(2).toList();
      rows.add(
        SizedBox(
          height: 124,
          child: Row(
            children: List.generate(rowItems.length, (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == rowItems.length - 1 ? 0 : AppSpacing.md,
                  ),
                  child: _DuahShortcutCard(item: rowItems[index]),
                ),
              );
            }),
          ),
        ),
      );

      if (start + 2 < items.length) {
        rows.add(const SizedBox(height: AppSpacing.md));
      }
    }

    return Column(children: rows);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Icon(icon, size: 17, color: color),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.dashboardSectionTitle.copyWith(
              color: colorScheme.onSurface,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }
}

class _DuahShortcutCard extends StatelessWidget {
  const _DuahShortcutCard({required this.item});

  final DashboardActionItem item;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final surface = isDark
        ? MyColors.darkCardFill.withValues(alpha: 0.86)
        : colorScheme.surface.withValues(alpha: 0.94);

    return Semantics(
      button: true,
      label: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Ink(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: colorScheme.outline.withValues(
                  alpha: isDark ? 0.22 : 0.16,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: item.color.withValues(alpha: isDark ? 0.15 : 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(AppRadius.compact),
                  ),
                  child: Icon(item.icon, size: 17, color: item.color),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.dashboardActionTitle.copyWith(
                    color: colorScheme.onSurface,
                    letterSpacing: 0,
                  ),
                ),
                if (item.sublabel != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.sublabel!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.dashboardActionSubtitle.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.58),
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GridHeader extends StatelessWidget {
  const _GridHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: MyColors.tertiary.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: const Icon(
            Icons.grid_view_rounded,
            size: 17,
            color: MyColors.tertiary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.sunnahDuaGridTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.dashboardSectionTitle.copyWith(
                  color: colorScheme.onSurface,
                  letterSpacing: 0,
                ),
              ),
              Text(
                context.l10n.sunnahDuaItemsCount(count),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.bodySmall.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.58),
                  fontWeight: AppTheme.weightSemiBold,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

part of '../../../views/dashboard/dashboard_view.dart';

class ActionTile extends StatelessWidget {
  final DashboardActionItem item;
  final bool isDark;
  final Color cardBg, textMain, textHint, divider;

  const ActionTile({
    super.key,
    required this.item,
    required this.isDark,
    required this.cardBg,
    required this.textMain,
    required this.textHint,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : divider.withOpacity(0.8),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: MyColors.primary.withOpacity(isDark ? 0.1 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppRadius.compact),
              ),
              child: Icon(item.icon, size: 18, color: item.color),
            ),
            const SizedBox(height: 12),
            Text(
              item.label,
              style: text.dashboardActionTitle.copyWith(color: textMain),
            ),
            if (item.sublabel != null) ...[
              const SizedBox(height: 2),
              Text(
                item.sublabel!,
                style: text.dashboardActionSubtitle.copyWith(color: textHint),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

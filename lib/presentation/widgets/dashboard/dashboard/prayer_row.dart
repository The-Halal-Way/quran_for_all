part of '../../../views/dashboard/dashboard_view.dart';

class PrayerRow extends StatelessWidget {
  final String name, time;
  final IconData icon;
  final bool isNext, isDark;
  final Color textMain, textHint, divider;

  const PrayerRow({
    super.key,
    required this.name,
    required this.time,
    required this.icon,
    required this.isNext,
    required this.isDark,
    required this.textMain,
    required this.textHint,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isNext
                  ? MyColors.secondary.withOpacity(0.12)
                  : (isDark
                        ? Colors.white.withOpacity(0.05)
                        : MyColors.divider.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 17,
              color: isNext ? MyColors.secondary : textHint,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style:
                (isNext
                        ? text.dashboardPrayerNameActive
                        : text.dashboardPrayerName)
                    .copyWith(color: isNext ? textMain : textHint),
          ),
          if (isNext) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: MyColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: MyColors.secondary.withOpacity(0.25),
                  width: 0.7,
                ),
              ),
              child: Text(
                context.l10n.dashboardNextShortLabel,
                style: text.dashboardTinyBadge.copyWith(
                  color: MyColors.secondary,
                ),
              ),
            ),
          ],
          const Spacer(),
          Text(
            time,
            style:
                (isNext
                        ? text.dashboardPrayerTimeActive
                        : text.dashboardPrayerTime)
                    .copyWith(color: isNext ? MyColors.secondary : textHint),
          ),
        ],
      ),
    );
  }
}

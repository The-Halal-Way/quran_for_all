import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart' show AppRadius;
import '../../../../core/theme/my_colors.dart';

class DashboardDailyReminderButton extends StatelessWidget {
  const DashboardDailyReminderButton({
    super.key,
    required this.label,
    required this.unreadCount,
    required this.onTap,
  });

  final String label;
  final int unreadCount;
  final VoidCallback onTap;

  String get _badgeLabel => unreadCount > 99 ? '99+' : '$unreadCount';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hasUnread = unreadCount > 0;
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        label: hasUnread ? '$label, $_badgeLabel' : label,
        child: SizedBox(
          width: 40,
          height: 35,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              PositionedDirectional(
                start: 0,
                bottom: 0,
                child: Material(
                  color: colors.surface,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: MyColors.secondary.withValues(alpha: 0.2),
                    ),
                  ),
                  elevation: 2,
                  shadowColor: MyColors.primary.withValues(alpha: 0.18),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onTap,
                    child: const SizedBox.square(
                      dimension: 38,
                      child: Icon(
                        CupertinoIcons.bell,
                        size: 23,
                        color: MyColors.secondary,
                      ),
                    ),
                  ),
                ),
              ),
              if (hasUnread)
                PositionedDirectional(
                  end: -5,
                  top: -10,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 22),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: MyColors.error,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(color: colors.surface, width: 2),
                    ),
                    child: Text(
                      _badgeLabel,
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.noScaling,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

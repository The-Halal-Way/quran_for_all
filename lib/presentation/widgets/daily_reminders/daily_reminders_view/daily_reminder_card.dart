import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/daily_reminders/daily_reminder_pack.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../models/daily_reminder_presenter.dart';
import '../../../viewmodels/daily_reminders/daily_reminders_viewmodel.dart';

class DailyReminderCard extends StatelessWidget {
  const DailyReminderCard({
    super.key,
    required this.record,
    required this.edition,
    required this.l10n,
    required this.dateLabel,
    required this.isRead,
    required this.isSaved,
    required this.onOpen,
    required this.onToggleSaved,
    this.featured = false,
  });

  final DailyReminderRecord record;
  final ResolvedDailyReminderEdition edition;
  final AppLocalizations l10n;
  final String dateLabel;
  final bool isRead;
  final bool isSaved;
  final VoidCallback onOpen;
  final VoidCallback onToggleSaved;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final color = dailyReminderKindColor(context, record.item.kind);
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      readOnly: isRead,
      label: '${edition.edition.title}. $dateLabel',
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: featured ? 5 : 1,
        child: InkWell(
          onTap: onOpen,
          child: Stack(
            children: [
              PositionedDirectional(
                start: 0,
                top: 0,
                bottom: 0,
                child: Container(width: 5, color: color),
              ),
              PositionedDirectional(
                end: -24,
                top: -24,
                child: Container(
                  width: featured ? 110 : 84,
                  height: featured ? 110 : 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withValues(alpha: 0.12),
                      width: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.xl,
                  featured ? AppSpacing.xl : AppSpacing.lg,
                  AppSpacing.md,
                  featured ? AppSpacing.xl : AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _MetaPill(
                          icon: dailyReminderKindIcon(record.item.kind),
                          text: dailyReminderKindLabel(l10n, record.item.kind),
                          color: color,
                        ),
                        Text(
                          dateLabel,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                        if (!isRead)
                          _MetaPill(
                            icon: CupertinoIcons.circle_fill,
                            text: l10n.dailyRemindersUnreadBadge,
                            color: scheme.secondary,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      edition.edition.title,
                      style:
                          (featured
                                  ? Theme.of(context).textTheme.headlineSmall
                                  : Theme.of(context).textTheme.titleLarge)
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: scheme.onSurface,
                                height: 1.2,
                              ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      edition.edition.summary,
                      maxLines: featured ? 4 : 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Icon(
                          isRead
                              ? CupertinoIcons.checkmark_circle_fill
                              : CupertinoIcons.circle,
                          size: 18,
                          color: isRead ? scheme.tertiary : scheme.outline,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          isRead
                              ? l10n.dailyRemindersRead
                              : l10n.dailyRemindersUnread,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: onToggleSaved,
                          tooltip: isSaved
                              ? l10n.dailyRemindersUnsave
                              : l10n.dailyRemindersSave,
                          icon: Icon(
                            isSaved
                                ? CupertinoIcons.bookmark_fill
                                : CupertinoIcons.bookmark,
                            color: isSaved
                                ? scheme.secondary
                                : scheme.onSurfaceVariant,
                          ),
                        ),
                        const Icon(CupertinoIcons.chevron_forward, size: 18),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.09),
      borderRadius: BorderRadius.circular(AppRadius.full),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(
          text,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

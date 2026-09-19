import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/daily_reminders/daily_reminder_pack.dart';
import '../../../../l10n/app_localizations.dart';

class DailyReminderSourceSection extends StatelessWidget {
  const DailyReminderSourceSection({
    super.key,
    required this.sources,
    required this.l10n,
    required this.onOpen,
  });

  final List<DailyReminderSource> sources;
  final AppLocalizations l10n;
  final ValueChanged<DailyReminderSource> onOpen;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        l10n.dailyRemindersSources,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: AppSpacing.sm),
      ...sources.map(
        (source) => Card(
          child: ListTile(
            leading: Icon(
              source.type == 'quran'
                  ? Icons.menu_book_rounded
                  : Icons.format_quote_rounded,
            ),
            title: Text(source.displayName),
            subtitle: source.grading == null ? null : Text(source.grading!),
            trailing: const Icon(CupertinoIcons.arrow_up_right, size: 19),
            onTap: () => onOpen(source),
          ),
        ),
      ),
    ],
  );
}

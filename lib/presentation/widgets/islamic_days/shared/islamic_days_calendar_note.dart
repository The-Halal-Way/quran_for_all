import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../views/dashboard/hijri_calendar/hijri_calendar_view.dart';

class IslamicDaysCalendarNote extends StatelessWidget {
  const IslamicDaysCalendarNote({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: .055),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.primary.withValues(alpha: .13)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: scheme.primary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.l10n.islamicDaysCalendarTitle,
                  style: AppTheme.text(context).titleSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.islamicDaysCalendarBody,
            style: AppTheme.text(context).bodySmall.copyWith(height: 1.6),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => Navigator.of(context).push(
              AppPageRoute<void>(builder: (_) => const HijriCalendarView()),
            ),
            icon: const Icon(Icons.tune_rounded, size: 18),
            label: Text(context.l10n.islamicDaysCalendarAction),
          ),
        ],
      ),
    );
  }
}

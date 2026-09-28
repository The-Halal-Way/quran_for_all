import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/dashboard/daily_tracker_viewmodel.dart';
import '../../../views/dashboard/when_you_have_a_need/need_amal.dart';

class NeedTrackerAction extends StatelessWidget {
  const NeedTrackerAction({
    super.key,
    required this.amal,
    required this.isBangla,
  });

  final NeedAmal amal;
  final bool isBangla;

  @override
  Widget build(BuildContext context) {
    final tracker = context.watch<DailyTrackerViewModel?>();
    final stableId = 'need_amal_${amal.id}';
    final alreadyAdded =
        tracker?.tasks.any((task) => task.id == 'reminder_$stableId') ?? false;
    return OutlinedButton.icon(
      key: ValueKey('need_add_tracker_${amal.id}'),
      onPressed: tracker == null || alreadyAdded
          ? null
          : () async {
              try {
                await tracker.addReminderTask(
                  contentId: stableId,
                  title: amal.title.en,
                  alternateLocaleTitle: amal.title.bn,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isBangla
                            ? 'দৈনিক ট্র্যাকারে যোগ হয়েছে'
                            : 'Added to Daily Tracker',
                      ),
                    ),
                  );
                }
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isBangla
                            ? 'ট্র্যাকারে যোগ করা যায়নি'
                            : 'Could not add to Daily Tracker',
                      ),
                    ),
                  );
                }
              }
            },
      icon: Icon(
        alreadyAdded ? Icons.check_rounded : Icons.playlist_add_rounded,
      ),
      label: Text(
        alreadyAdded
            ? (isBangla ? 'দৈনিক ট্র্যাকারে আছে' : 'In Daily Tracker')
            : (isBangla ? 'দৈনিক ট্র্যাকারে যোগ করুন' : 'Add to Daily Tracker'),
      ),
    );
  }
}

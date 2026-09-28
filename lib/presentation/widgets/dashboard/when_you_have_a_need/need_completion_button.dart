import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/dashboard/need_amal_progress_viewmodel.dart';

class NeedCompletionButton extends StatelessWidget {
  const NeedCompletionButton({
    super.key,
    required this.amalId,
    required this.isBangla,
  });

  final String amalId;
  final bool isBangla;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NeedAmalProgressViewModel>();
    final done = vm.isCompleted(amalId);
    return OutlinedButton.icon(
      key: ValueKey('need_done_$amalId'),
      onPressed: vm.isLoaded ? () => vm.toggleComplete(amalId) : null,
      icon: Icon(done ? Icons.check_circle_rounded : Icons.circle_outlined),
      label: Text(
        done
            ? (isBangla ? 'আজ সম্পন্ন' : 'Done today')
            : (isBangla ? 'আজ সম্পন্ন করুন' : 'Mark done today'),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<TimeOfDay?> showAppTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
}) {
  var selected = initialTime;
  final initialDate = DateTime(
    2020,
    1,
    1,
    initialTime.hour,
    initialTime.minute,
  );
  return showCupertinoModalPopup<TimeOfDay>(
    context: context,
    builder: (sheetContext) => _PickerSheet(
      onCancel: () => Navigator.pop(sheetContext),
      onDone: () => Navigator.pop(sheetContext, selected),
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.time,
        initialDateTime: initialDate,
        use24hFormat: MediaQuery.alwaysUse24HourFormatOf(context),
        onDateTimeChanged: (value) {
          selected = TimeOfDay(hour: value.hour, minute: value.minute);
        },
      ),
    ),
  );
}

Future<DateTime?> showAppDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  var selected = initialDate;
  return showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (sheetContext) => _PickerSheet(
      onCancel: () => Navigator.pop(sheetContext),
      onDone: () => Navigator.pop(sheetContext, selected),
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: initialDate,
        minimumDate: firstDate,
        maximumDate: lastDate,
        onDateTimeChanged: (value) => selected = value,
      ),
    ),
  );
}

class _PickerSheet extends StatelessWidget {
  const _PickerSheet({
    required this.child,
    required this.onCancel,
    required this.onDone,
  });

  final Widget child;
  final VoidCallback onCancel;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final background = CupertinoColors.systemBackground.resolveFrom(context);
    final separator = CupertinoColors.separator.resolveFrom(context);
    final materialL10n = MaterialLocalizations.of(context);
    return Container(
      height: 336,
      decoration: BoxDecoration(
        color: background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            SizedBox(
              height: 52,
              child: Row(
                children: [
                  CupertinoButton(
                    onPressed: onCancel,
                    child: Text(materialL10n.cancelButtonLabel),
                  ),
                  const Spacer(),
                  CupertinoButton(
                    onPressed: onDone,
                    child: Text(
                      materialL10n.okButtonLabel,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 0.5, thickness: 0.5, color: separator),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

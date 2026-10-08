import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';

Future<void> saveIslamicDaysChange(
  BuildContext context,
  Future<void> Function() operation, {
  String? success,
}) async {
  try {
    await operation();
    if (context.mounted && success != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(success)));
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.islamicDaysSaveError)),
      );
    }
  }
}

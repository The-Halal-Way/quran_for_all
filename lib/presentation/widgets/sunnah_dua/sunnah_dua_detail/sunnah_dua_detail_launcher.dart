import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../models/sunnah_dua_item.dart';
import 'sunnah_dua_detail_sheet.dart';

Future<void> showSunnahDuaDetails(BuildContext context, SunnahDuaItem item) {
  FocusScope.of(context).unfocus();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    barrierColor: MyColors.primaryDark.withValues(alpha: 0.58),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (sheetContext) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.78,
      minChildSize: 0.38,
      maxChildSize: 0.94,
      builder: (context, controller) => SunnahDuaDetailSheet(
        controller: controller,
        item: item,
        kindLabel: switch (item.kind) {
          SunnahDuaKind.sunnah => context.l10n.sunnahDuaKindSunnah,
          SunnahDuaKind.dua => context.l10n.sunnahDuaKindDua,
          SunnahDuaKind.dhikr => context.l10n.sunnahDuaKindDhikr,
        },
      ),
    ),
  );
}

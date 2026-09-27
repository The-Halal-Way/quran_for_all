import 'package:flutter/material.dart';

import '../../../../core/theme/my_colors.dart';
import '../../../views/prayer/eid_prayer/eid_prayer_models.dart';

class EidGuideStyle {
  const EidGuideStyle._();

  static Color accent(EidKind eid) =>
      eid == EidKind.fitr ? MyColors.tertiary : MyColors.secondary;

  static Color brightAccent(EidKind eid) =>
      eid == EidKind.fitr ? MyColors.tertiaryLight : MyColors.secondaryLight;

  static LinearGradient heroGradient(EidKind eid) => LinearGradient(
    colors: eid == EidKind.fitr
        ? [MyColors.primaryDark, MyColors.primary, MyColors.tertiaryDark]
        : [MyColors.primaryDark, MyColors.primary, MyColors.secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../views/dashboard/when_you_have_a_need/need_amal.dart';

class NeedReferencesList extends StatelessWidget {
  const NeedReferencesList({
    super.key,
    required this.amal,
    required this.isBangla,
  });

  final NeedAmal amal;
  final bool isBangla;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        isBangla ? 'কুরআন ও হাদিস সূত্র' : 'Quran and Hadith references',
        style: AppTheme.text(
          context,
        ).titleLarge.copyWith(fontWeight: AppTheme.weightExtraBold),
      ),
      const SizedBox(height: AppSpacing.sm),
      for (final reference in amal.references)
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: () => launchUrl(
              Uri.parse(reference.url),
              mode: LaunchMode.externalApplication,
            ),
            icon: const Icon(Icons.open_in_new_rounded, size: 17),
            label: Text(reference.label),
          ),
        ),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../viewmodels/dashboard/need_amal_progress_viewmodel.dart';
import '../../../views/dashboard/when_you_have_a_need/need_amal.dart';

class NeedProgressControl extends StatelessWidget {
  const NeedProgressControl({
    super.key,
    required this.kind,
    required this.isBangla,
  });

  final NeedProgressKind kind;
  final bool isBangla;

  @override
  Widget build(BuildContext context) {
    if (kind == NeedProgressKind.daily) return const SizedBox.shrink();
    final vm = context.watch<NeedAmalProgressViewModel>();
    final count = kind == NeedProgressKind.juz ? vm.juz : vm.yunusCount;
    final target = kind == NeedProgressKind.juz ? 30 : 100;
    final scheme = Theme.of(context).colorScheme;
    final label = kind == NeedProgressKind.juz
        ? (isBangla ? 'পড়া জুজ' : 'Juz read')
        : (isBangla
              ? 'ব্যক্তিগত গণনা · নির্ধারিত নয়'
              : 'Personal count · not prescribed');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.tertiary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTheme.text(context).labelSmall.copyWith(
                    fontWeight: AppTheme.weightBold,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                '$count / $target',
                key: ValueKey('need_progress_${kind.name}'),
                style: AppTheme.text(context).titleSmall.copyWith(
                  color: scheme.tertiary,
                  fontWeight: AppTheme.weightExtraBold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              if (kind == NeedProgressKind.juz)
                Expanded(
                  child: LinearProgressIndicator(
                    value: count / target,
                    color: scheme.tertiary,
                    backgroundColor: scheme.tertiary.withValues(alpha: 0.12),
                  ),
                )
              else
                const Spacer(),
              IconButton(
                key: ValueKey('need_decrease_${kind.name}'),
                visualDensity: VisualDensity.compact,
                tooltip: isBangla ? 'এক কমান' : 'Decrease by one',
                onPressed: vm.isLoaded && count > 0
                    ? () => _change(vm, -1)
                    : null,
                icon: const Icon(Icons.remove_circle_outline_rounded),
              ),
              IconButton(
                key: ValueKey('need_increase_${kind.name}'),
                visualDensity: VisualDensity.compact,
                tooltip: isBangla ? 'এক যোগ করুন' : 'Add one',
                onPressed:
                    vm.isLoaded &&
                        count < (kind == NeedProgressKind.juz ? 30 : 9999)
                    ? () => _change(vm, 1)
                    : null,
                icon: const Icon(Icons.add_circle_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _change(NeedAmalProgressViewModel vm, int delta) {
    if (kind == NeedProgressKind.juz) {
      vm.changeJuz(delta);
    } else {
      vm.changeYunusCount(delta);
    }
  }
}

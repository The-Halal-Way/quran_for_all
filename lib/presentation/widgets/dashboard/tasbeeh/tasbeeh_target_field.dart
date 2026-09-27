import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../domain/entities/tasbeeh/tasbeeh_phrase.dart';

class TasbeehTargetField extends StatelessWidget {
  const TasbeehTargetField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => TextFormField(
    key: const ValueKey('tasbeeh_target_field'),
    controller: controller,
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.done,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    maxLength: 6,
    decoration: InputDecoration(
      labelText: context.l10n.tasbeehTarget,
      prefixIcon: const Icon(Icons.track_changes_rounded),
      counterText: '',
    ),
    validator: (value) {
      final target = int.tryParse(value?.trim() ?? '');
      return target != null && TasbeehPhrase.validTarget(target)
          ? null
          : context.l10n.tasbeehTargetRange;
    },
    onFieldSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
  );
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/models/dhikr_reminders/custom_dhikr_reminder.dart';
import '../../../../data/models/dhikr_reminders/dhikr_reminder.dart';
import '../../../../services/dhikr_reminders/dhikr_sound_preview.dart';
import '../../../viewmodels/dhikr_reminders/dhikr_reminders_viewmodel.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/dhikr_reminders/custom_reminder_fields.dart';
import '../../../widgets/dhikr_reminders/dhikr_interval_sheet.dart';
import '../../../widgets/dhikr_reminders/dhikr_notification_preview.dart';
import '../../../widgets/dhikr_reminders/dhikr_reminder_labels.dart';
import '../../../widgets/dhikr_reminders/dhikr_sound_sheet.dart';

class CustomDhikrReminderEditorView extends StatefulWidget {
  const CustomDhikrReminderEditorView({super.key, this.reminder});
  final CustomDhikrReminder? reminder;

  @override
  State<CustomDhikrReminderEditorView> createState() =>
      _CustomDhikrReminderEditorViewState();
}

class _CustomDhikrReminderEditorViewState
    extends State<CustomDhikrReminderEditorView> {
  final _form = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.reminder?.title ?? '');
  late final _subtitle = TextEditingController(
    text: widget.reminder?.subtitle ?? '',
  );
  late DhikrReminder _settings =
      widget.reminder?.settings ?? const DhikrReminder(enabled: true);
  final _preview = DhikrSoundPreview();
  bool _saving = false;
  DhikrReminderError? _error;

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _saving = true;
      _error = null;
    });
    await _preview.stop();
    if (!mounted) return;
    final vm = context.read<DhikrRemindersViewModel>();
    final saved = await vm.saveCustom(
      id: widget.reminder?.id,
      title: _title.text,
      subtitle: _subtitle.text,
      settings: _settings,
    );
    if (!mounted) return;
    setState(() {
      _saving = false;
      _error = saved ? null : vm.error;
    });
    if (saved) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context, true);
      });
    }
  }

  Future<void> _chooseSound() async {
    FocusScope.of(context).unfocus();
    await _preview.stop();
    if (!mounted) return;
    final sound = await showDhikrSoundSheet(
      context,
      _settings.sound,
      preview: _preview,
    );
    if (sound != null && mounted) {
      setState(() => _settings = _settings.copyWith(sound: sound));
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _subtitle.dispose();
    _preview.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopScope(
      canPop: !_saving,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.reminder == null
                ? l10n.dhikrNewCustom
                : l10n.dhikrEditCustom,
          ),
        ),
        body: AppPremiumPageBackground(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                children: [
                  Expanded(
                    child: Form(
                      key: _form,
                      child: ListView(
                        padding: EdgeInsets.all(
                          AppResponsive.of(context).padding,
                        ),
                        children: [
                          DhikrNotificationPreview(
                            title: _title.text,
                            subtitle: _subtitle.text,
                            sound: _settings.sound,
                            preview: _preview,
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          CustomReminderFields(
                            title: _title,
                            subtitle: _subtitle,
                            settings: _settings,
                            preview: _preview,
                            busy: _saving,
                            onChanged: () => setState(() {}),
                            onEnabled: (enabled) => setState(
                              () => _settings = _settings.copyWith(
                                enabled: enabled,
                              ),
                            ),
                            onInterval: () async {
                              FocusScope.of(context).unfocus();
                              await _preview.stop();
                              if (!context.mounted) return;
                              final minutes = await showDhikrIntervalSheet(
                                context,
                                _settings.intervalMinutes,
                              );
                              if (minutes != null && mounted) {
                                setState(
                                  () => _settings = _settings.copyWith(
                                    intervalMinutes: minutes,
                                  ),
                                );
                              }
                            },
                            onSound: _chooseSound,
                          ),
                          if (_error != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: AppSpacing.md,
                              ),
                              child: Text(
                                dhikrErrorText(l10n, _error!),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.sm,
                        AppSpacing.lg,
                        AppSpacing.md,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _saving ? null : _save,
                          icon: _saving
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.check_rounded),
                          label: Text(l10n.dhikrSaveReminder),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

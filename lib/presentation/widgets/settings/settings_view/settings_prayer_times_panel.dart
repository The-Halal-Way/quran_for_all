import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../data/datasources/local/prayer_times_preferences_store.dart';
import '../../../../domain/entities/prayer_times/prayer_times_models.dart';
import '../../../viewmodels/dashboard_prayer_times_viewmodel.dart';
import 'settings_panel.dart';

class SettingsPrayerTimesPanel extends StatefulWidget {
  const SettingsPrayerTimesPanel({super.key});

  @override
  State<SettingsPrayerTimesPanel> createState() =>
      _SettingsPrayerTimesPanelState();
}

class _SettingsPrayerTimesPanelState extends State<SettingsPrayerTimesPanel> {
  static const _mainOffsets = [
    'fajr',
    'sunrise',
    'dhuhr',
    'asr',
    'maghrib',
    'isha',
  ];
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _offsetControllers = {
    for (final key in _mainOffsets) key: TextEditingController(text: '0'),
  };

  PrayerCalculationConfig? _config;
  PrayerCalculationMethod _method = PrayerCalculationMethod.muslimWorldLeague;
  PrayerMadhab _madhab = PrayerMadhab.shafi;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final config = await context
        .read<PrayerTimesPreferencesStore>()
        .getCalculationConfig();
    if (!mounted) return;
    setState(() {
      _config = config;
      _method = config.method;
      _madhab = config.madhab;
      final adjustments = config.adjustments.toMap();
      for (final key in _mainOffsets) {
        _offsetControllers[key]!.text = adjustments[key]!.toString();
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _offsetControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  int? _parseMinutes(String text) {
    final ascii = text.trim().replaceAllMapped(RegExp(r'[০-৯٠-٩۰-۹]'), (match) {
      final code = match.group(0)!.runes.single;
      final digit = code >= 0x09E6 && code <= 0x09EF
          ? code - 0x09E6
          : code >= 0x0660 && code <= 0x0669
          ? code - 0x0660
          : code - 0x06F0;
      return digit.toString();
    });
    final value = int.tryParse(ascii);
    return value != null && value >= -60 && value <= 60 ? value : null;
  }

  String _offsetLabel(BuildContext context, String key) => switch (key) {
    'fajr' => context.l10n.settingsPrayerOffsetFajr,
    'sunrise' => context.l10n.settingsPrayerOffsetSunrise,
    'dhuhr' => context.l10n.settingsPrayerOffsetDhuhr,
    'asr' => context.l10n.settingsPrayerOffsetAsr,
    'maghrib' => context.l10n.settingsPrayerOffsetMaghrib,
    'isha' => context.l10n.settingsPrayerOffsetIsha,
    _ => throw ArgumentError.value(key, 'key'),
  };

  String _methodLabel(
    BuildContext context,
    PrayerCalculationMethod method,
  ) => switch (method) {
    PrayerCalculationMethod.karachi => context.l10n.settingsPrayerMethodKarachi,
    PrayerCalculationMethod.islamicSocietyOfNorthAmerica =>
      context.l10n.settingsPrayerMethodIsna,
    PrayerCalculationMethod.muslimWorldLeague =>
      context.l10n.settingsPrayerMethodMwl,
    PrayerCalculationMethod.ummAlQura =>
      context.l10n.settingsPrayerMethodUmmAlQura,
    PrayerCalculationMethod.egyptian =>
      context.l10n.settingsPrayerMethodEgyptian,
    PrayerCalculationMethod.gulf => context.l10n.settingsPrayerMethodGulf,
    PrayerCalculationMethod.kuwait => context.l10n.settingsPrayerMethodKuwait,
    PrayerCalculationMethod.qatar => context.l10n.settingsPrayerMethodQatar,
    PrayerCalculationMethod.singapore =>
      context.l10n.settingsPrayerMethodSingapore,
    PrayerCalculationMethod.turkey => context.l10n.settingsPrayerMethodTurkey,
    PrayerCalculationMethod.moonsightingCommittee =>
      context.l10n.settingsPrayerMethodMoonsighting,
    PrayerCalculationMethod.malaysia =>
      context.l10n.settingsPrayerMethodMalaysia,
    PrayerCalculationMethod.indonesia =>
      context.l10n.settingsPrayerMethodIndonesia,
  };

  Widget _offsetRow(BuildContext context, String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _offsetLabel(context, key),
              style: AppTheme.text(context).bodyMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 112,
            child: TextFormField(
              key: ValueKey('prayer-adjustment-$key'),
              controller: _offsetControllers[key],
              enabled: !_saving,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                isDense: true,
                labelText: context.l10n.settingsPrayerOffsetMinutes,
                border: const OutlineInputBorder(),
              ),
              validator: (value) => _parseMinutes(value ?? '') == null
                  ? context.l10n.settingsPrayerOffsetInvalid
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final current = _config;
    if (current == null || _saving || !_formKey.currentState!.validate()) {
      return;
    }

    final values = {
      for (final key in _mainOffsets)
        key: _parseMinutes(_offsetControllers[key]!.text)!,
    };
    final updated = current.copyWith(
      method: _method,
      madhab: _madhab,
      adjustments: PrayerAdjustments(
        fajr: values['fajr']!,
        sunrise: values['sunrise']!,
        dhuhr: values['dhuhr']!,
        asr: values['asr']!,
        maghrib: values['maghrib']!,
        isha: values['isha']!,
      ),
    );

    setState(() => _saving = true);
    try {
      await context.read<PrayerTimesPreferencesStore>().saveCalculationConfig(
        updated,
      );
      if (!mounted) return;
      setState(() => _config = updated);
      unawaited(
        context
            .read<DashboardPrayerTimesViewModel>()
            .reloadForCalculationChange(),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.settingsPrayerSaved)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.settingsPrayerSaveFailed)),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsPanel(
      title: context.l10n.settingsPrayerTimesTitle,
      icon: Icons.access_time_outlined,
      accent: MyColors.tertiary,
      child: _config == null
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.settingsPrayerTimesDescription,
                    style: AppTheme.text(context).bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  DropdownButtonFormField<PrayerCalculationMethod>(
                    key: const ValueKey('prayer-method'),
                    initialValue: _method,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: context.l10n.settingsPrayerMethodLabel,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      for (final method in PrayerCalculationMethod.values)
                        DropdownMenuItem(
                          value: method,
                          child: Text(
                            _methodLabel(context, method),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: _saving
                        ? null
                        : (value) {
                            if (value != null) setState(() => _method = value);
                          },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<PrayerMadhab>(
                    key: const ValueKey('prayer-school'),
                    initialValue: _madhab,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: context.l10n.settingsPrayerSchoolLabel,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: PrayerMadhab.shafi,
                        child: Text(
                          context.l10n.settingsPrayerSchoolStandard,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DropdownMenuItem(
                        value: PrayerMadhab.hanafi,
                        child: Text(context.l10n.settingsPrayerSchoolHanafi),
                      ),
                    ],
                    onChanged: _saving
                        ? null
                        : (value) {
                            if (value != null) setState(() => _madhab = value);
                          },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    context.l10n.settingsPrayerAdjustmentsTitle,
                    style: AppTheme.text(context).titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    context.l10n.settingsPrayerAdjustmentsDescription,
                    style: AppTheme.text(context).bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  for (final key in _mainOffsets) _offsetRow(context, key),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.sm,
                    alignment: WrapAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _saving
                            ? null
                            : () {
                                for (final controller
                                    in _offsetControllers.values) {
                                  controller.text = '0';
                                }
                                _formKey.currentState?.validate();
                              },
                        child: Text(context.l10n.settingsPrayerResetOffsets),
                      ),
                      FilledButton(
                        onPressed: _saving ? null : _save,
                        child: Text(context.l10n.settingsPrayerSave),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

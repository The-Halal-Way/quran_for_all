import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../views/dashboard/ramadan/ramadan_models.dart';

class RamadanMakeUpLog extends StatefulWidget {
  const RamadanMakeUpLog({super.key, required this.isBangla});

  final bool isBangla;

  @override
  State<RamadanMakeUpLog> createState() => _RamadanMakeUpLogState();
}

class _RamadanMakeUpLogState extends State<RamadanMakeUpLog> {
  static const _key = 'ramadan_make_up_days';
  int _days = 0;
  bool _loaded = false;
  Future<void> _pendingSave = Future.value();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        _days = (prefs.getInt(_key) ?? 0).clamp(0, 999);
        _loaded = true;
      });
    } catch (_) {
      if (mounted) setState(() => _loaded = true);
    }
  }

  void _change(int delta) {
    final updated = (_days + delta).clamp(0, 999);
    if (updated == _days) return;
    setState(() => _days = updated);
    _pendingSave = _pendingSave.then((_) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_key, updated);
      } catch (_) {
        // The personal log remains usable for this session when storage fails.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: scheme.tertiary.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: scheme.tertiary.withValues(alpha: 0.24)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ramadanLabel(
                    widget.isBangla,
                    'Make-up days log',
                    'কাজা দিনের হিসাব',
                  ),
                  style: AppTheme.text(
                    context,
                  ).titleSmall.copyWith(fontWeight: AppTheme.weightExtraBold),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  ramadanLabel(
                    widget.isBangla,
                    'Private count only. Your qada or fidyah ruling depends on your situation.',
                    'শুধু ব্যক্তিগত হিসাব। কাজা বা ফিদইয়ার বিধান আপনার অবস্থার ওপর নির্ভর করে।',
                  ),
                  style: AppTheme.text(context).bodySmall.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            children: [
              Text(
                '$_days',
                style: AppTheme.text(context).headlineMedium.copyWith(
                  color: scheme.tertiary,
                  fontWeight: AppTheme.weightBlack,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    key: const ValueKey('ramadan_log_decrease'),
                    tooltip: ramadanLabel(
                      widget.isBangla,
                      'Remove one day',
                      'এক দিন কমান',
                    ),
                    onPressed: _loaded && _days > 0 ? () => _change(-1) : null,
                    icon: const Icon(CupertinoIcons.minus_circle),
                  ),
                  IconButton(
                    key: const ValueKey('ramadan_log_increase'),
                    tooltip: ramadanLabel(
                      widget.isBangla,
                      'Add one day',
                      'এক দিন যোগ করুন',
                    ),
                    onPressed: _loaded ? () => _change(1) : null,
                    icon: const Icon(CupertinoIcons.plus_circle_fill),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

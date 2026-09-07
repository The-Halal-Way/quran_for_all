import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class SunnahDuaSectionSearch extends StatefulWidget {
  const SunnahDuaSectionSearch({
    super.key,
    required this.hint,
    required this.query,
    required this.onChanged,
  });

  final String hint;
  final String query;
  final ValueChanged<String> onChanged;

  @override
  State<SunnahDuaSectionSearch> createState() => _SunnahDuaSectionSearchState();
}

class _SunnahDuaSectionSearchState extends State<SunnahDuaSectionSearch> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.query,
  );

  @override
  void didUpdateWidget(covariant SunnahDuaSectionSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller.text != widget.query) _controller.text = widget.query;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => FocusScope.of(context).unfocus(),
      style: AppTheme.text(context).bodyMedium,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: AppTheme.text(
          context,
        ).bodySmall.copyWith(color: colors.onSurfaceVariant),
        prefixIcon: Icon(Icons.search_rounded, color: colors.onSurfaceVariant),
        suffixIcon: widget.query.isEmpty
            ? null
            : IconButton(
                tooltip: context.l10n.sunnahDuaClearSearch,
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                },
                icon: const Icon(Icons.close_rounded, size: 18),
              ),
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: colors.outline.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: colors.primary),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

class NintyNineNamesSearchField extends StatefulWidget {
  const NintyNineNamesSearchField({
    super.key,
    required this.query,
    required this.onChanged,
  });

  final String query;
  final ValueChanged<String> onChanged;

  @override
  State<NintyNineNamesSearchField> createState() =>
      _NintyNineNamesSearchFieldState();
}

class _NintyNineNamesSearchFieldState extends State<NintyNineNamesSearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.query,
  );

  @override
  void didUpdateWidget(NintyNineNamesSearchField oldWidget) {
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
      key: const ValueKey('ninty_nine_names_search'),
      controller: _controller,
      onChanged: widget.onChanged,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      onSubmitted: (_) => FocusScope.of(context).unfocus(),
      textInputAction: TextInputAction.search,
      style: AppTheme.text(context).bodyMedium,
      decoration: InputDecoration(
        hintText: context.l10n.duahNintyNineSearchHint,
        hintStyle: AppTheme.text(
          context,
        ).bodySmall.copyWith(color: colors.onSurfaceVariant),
        prefixIcon: Icon(Icons.search_rounded, color: colors.primary),
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
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
    );
  }
}

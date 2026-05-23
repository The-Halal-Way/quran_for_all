part of '../../../../views/dashboard/duah/daily_duah_view.dart';
class _DuahAppBar extends StatelessWidget {
  const _DuahAppBar({
    required this.isDark,
    required this.selectedLevel,
    required this.onLevelChanged,
  });

  final bool isDark;
  final DuahLevel selectedLevel;
  final ValueChanged<DuahLevel> onLevelChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardBg = colorScheme.surface.withValues(alpha: 0.9);
    final borderC = colorScheme.outline.withValues(alpha: 0.28);

    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.tertiary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.24),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.24),
                    Colors.white.withValues(alpha: 0.06),
                    Colors.white.withValues(alpha: 0.16),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.18),
                  width: 0.8,
                ),
              ),
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Du\'ā\'',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Supplications for every moment',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
      // flexibleSpace: FlexibleSpaceBar(
      //   collapseMode: CollapseMode.pin,
      //   titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      //   title: Text(
      //     'Daily Du\'ā\'',
      //     style: theme.textTheme.titleLarge?.copyWith(
      //       color: isDark ? const Color(0xFFEDE7F6) :  Colors.black,
      //     ),
      //   ),
      //   background: Padding(
      //     padding: const EdgeInsets.fromLTRB(20, 80, 20, 12),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Text(
      //           'Supplications for every moment',
      //           style: theme.textTheme.bodySmall?.copyWith(
      //             color: isDark
      //                 ? const Color(0xFF7E57C2)
      //                 : const Color(0xFF7A7288),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(52),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderC),
          ),
          child: Row(
            children: DuahLevel.values.map((level) {
              return Expanded(
                child: _LevelTab(
                  level: level,
                  isSelected: selectedLevel == level,
                  isDark: isDark,
                  onTap: () => onLevelChanged(level),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LEVEL TAB CHIP
// ─────────────────────────────────────────────────────────────────────────────

class _LevelTab extends StatelessWidget {
  const _LevelTab({
    required this.level,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final DuahLevel level;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  String get _label {
    switch (level) {
      case DuahLevel.beginner:
        return 'Beginner';
      case DuahLevel.intermediate:
        return 'Intermediate';
      case DuahLevel.advanced:
        return 'Advanced';
    }
  }

  Color get _activeColor {
    switch (level) {
      case DuahLevel.beginner:
        return const Color(0xFF00BFA5); // teal
      case DuahLevel.intermediate:
        return const Color(0xFF4B30A1); // indigo
      case DuahLevel.advanced:
        return const Color(0xFFD50057); // fuchsia
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? _activeColor.withValues(alpha: isDark ? 0.22 : 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          border: isSelected
              ? Border.all(color: _activeColor.withValues(alpha: 0.5), width: 1)
              : null,
        ),
        child: Text(
          _label,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? _activeColor
                : (isDark ? const Color(0xFF7E57C2) : const Color(0xFF7A7288)),
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 11.5,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LEVEL BANNER  (count chip + description)
// ─────────────────────────────────────────────────────────────────────────────

class _LevelBanner extends StatelessWidget {
  const _LevelBanner({required this.level, required this.isDark});

  final DuahLevel level;
  final bool isDark;

  String get _description {
    switch (level) {
      case DuahLevel.beginner:
        return 'Short, easy-to-memorize du\'ās for everyday moments. Perfect to start your journey.';
      case DuahLevel.intermediate:
        return 'Fuller wordings with richer meaning. Ideal once the basics feel natural.';
      case DuahLevel.advanced:
        return 'Complete authentic du\'ās including optional additions and all daily situations.';
    }
  }

  Color get _accentColor {
    switch (level) {
      case DuahLevel.beginner:
        return const Color(0xFF00BFA5);
      case DuahLevel.intermediate:
        return const Color(0xFF4B30A1);
      case DuahLevel.advanced:
        return const Color(0xFFD50057);
    }
  }

  String get _levelLabel {
    switch (level) {
      case DuahLevel.beginner:
        return 'Beginner';
      case DuahLevel.intermediate:
        return 'Intermediate';
      case DuahLevel.advanced:
        return 'Advanced';
    }
  }

  int get _duahCount =>
      DuahData.forLevel(level).fold(0, (sum, cat) => sum + cat.items.length);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBg = isDark ? const Color(0xFF1D1238) : Colors.white;
    final borderC = isDark ? const Color(0xFF382E54) : const Color(0xFFD9D1E8);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderC),
        gradient: LinearGradient(
          colors: [
            _accentColor.withValues(alpha: isDark ? 0.10 : 0.05),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: _accentColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _levelLabel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: _accentColor,
                        fontFamily: 'Sora',
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$_duahCount du\'ās',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _accentColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? const Color(0xFFB39DDB)
                        : const Color(0xFF4C425C),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CATEGORY SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
    required this.isDark,
    required this.isLast,
  });

  final DuahCategory category;
  final bool isDark;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 4, 16, isLast ? 32 : 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF1E0A3C,
                    ).withValues(alpha: isDark ? 0.6 : 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    category.icon,
                    size: 16,
                    color: isDark
                        ? const Color(0xFFB39DDB)
                        : const Color(0xFF1E0A3C),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  category.label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: 'Sora',
                    fontSize: 15,
                    color: isDark
                        ? const Color(0xFFEDE7F6)
                        : const Color(0xFF120B24),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF382E54)
                        : const Color(0xFFEEE8FA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${category.items.length}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isDark
                          ? const Color(0xFFB39DDB)
                          : const Color(0xFF4C425C),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Items
          ...category.items.map(
            (item) => _DuahCard(item: item, isDark: isDark),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DUAH CARD
// ─────────────────────────────────────────────────────────────────────────────

class _DuahCard extends StatefulWidget {
  const _DuahCard({required this.item, required this.isDark});

  final DuahItem item;
  final bool isDark;

  @override
  State<_DuahCard> createState() => _DuahCardState();
}

class _DuahCardState extends State<_DuahCard> {
  bool _expanded = false;
  bool _copied = false;

  void _copyToClipboard() {
    Clipboard.setData(
      ClipboardData(
        text:
            '${widget.item.arabic}\n${widget.item.pronunciation}\n${widget.item.translation}',
      ),
    );
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = widget.isDark;
    final item = widget.item;

    final cardBg = isDark ? const Color(0xFF120A2B) : Colors.white;
    final borderC = isDark ? const Color(0xFF382E54) : const Color(0xFFD9D1E8);
    final hasExtra = item.subItems.isNotEmpty || item.note != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderC),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Main content ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: isDark
                              ? const Color(0xFF7E57C2)
                              : const Color(0xFF4C425C),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    // Copy button
                    GestureDetector(
                      onTap: _copyToClipboard,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _copied
                              ? const Color(0xFF00BFA5).withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _copied ? Icons.check_rounded : Icons.copy_rounded,
                          size: 16,
                          color: _copied
                              ? const Color(0xFF00BFA5)
                              : (isDark
                                    ? const Color(0xFF7E57C2)
                                    : const Color(0xFF7A7288)),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Arabic text
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF1E0A3C,
                    ).withValues(alpha: isDark ? 0.40 : 0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(
                        0xFF4B30A1,
                      ).withValues(alpha: isDark ? 0.20 : 0.10),
                    ),
                  ),
                  child: Text(
                    item.arabic,
                    textAlign: TextAlign.right,
                    textDirection: ui.TextDirection.rtl,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontFamily: 'Scheherazade New', // Arabic font
                      fontSize: 24,
                      height: 1.8,
                      color: isDark
                          ? const Color(0xFFEDE7F6)
                          : const Color(0xFF120B24),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Pronunciation
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 3,
                      height: 14,
                      margin: const EdgeInsets.only(top: 2, right: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4B30A1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.pronunciation,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: isDark
                              ? const Color(0xFFB39DDB)
                              : const Color(0xFF4C425C),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Translation
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 3,
                      height: 14,
                      margin: const EdgeInsets.only(top: 2, right: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BFA5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.translation,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? const Color(0xFFEDE7F6)
                              : const Color(0xFF120B24),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),

                // Note (if any)
                if (item.note != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00BFA5).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF00BFA5).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color: Color(0xFF00BFA5),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.note!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? const Color(0xFF64FFDA)
                                  : const Color(0xFF00897B),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Expand toggle for sub-items ───────────────────────────────────
          if (hasExtra) ...[
            Divider(height: 1, color: borderC),
            InkWell(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: isDark
                          ? const Color(0xFF7E57C2)
                          : const Color(0xFF4C425C),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _expanded ? 'Hide variants' : 'Show variants',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isDark
                            ? const Color(0xFF7E57C2)
                            : const Color(0xFF4C425C),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sub-items (e.g. "If forgotten")
            if (_expanded)
              ...item.subItems.map(
                (sub) => _SubItemTile(item: sub, isDark: isDark),
              ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SUB ITEM  (variant / optional addition)
// ─────────────────────────────────────────────────────────────────────────────

class _SubItemTile extends StatelessWidget {
  const _SubItemTile({required this.item, required this.isDark});

  final DuahItem item;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFD50057).withValues(alpha: isDark ? 0.07 : 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD50057).withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            item.title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: const Color(0xFFD50057),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.arabic,
            textAlign: TextAlign.right,
            textDirection: ui.TextDirection.rtl,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontFamily: 'Scheherazade New',
              fontSize: 20,
              height: 1.8,
              color: isDark ? const Color(0xFFEDE7F6) : const Color(0xFF120B24),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.pronunciation,
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: isDark ? const Color(0xFFB39DDB) : const Color(0xFF4C425C),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.translation,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? const Color(0xFFEDE7F6) : const Color(0xFF120B24),
            ),
          ),
        ],
      ),
    );
  }
}

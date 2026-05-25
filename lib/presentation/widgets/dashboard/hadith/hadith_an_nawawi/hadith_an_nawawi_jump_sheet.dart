part of '../../../../views/dashboard/hadith/hadith_an_nawawi_view.dart';

class _JumpSheet extends StatefulWidget {
  final HadithBook book;
  final bool isDark, isBangla;
  final Color cardBg, textMain, textHint, divider;
  final TextEditingController controller;
  final void Function(int index) onJump;

  const _JumpSheet({
    required this.book,
    required this.isDark,
    required this.isBangla,
    required this.cardBg,
    required this.textMain,
    required this.textHint,
    required this.divider,
    required this.controller,
    required this.onJump,
  });

  @override
  State<_JumpSheet> createState() => _JumpSheetState();
}

class _JumpSheetState extends State<_JumpSheet> {
  String _query = '';

  // Intro is index -1; hadiths are 0-based indices
  // We show intro as the first item, then all hadiths
  List<_JumpItem> get _allItems {
    final intro = _JumpItem(
      index: -1,
      arabic: 'مقدمة',
      label: widget.isBangla ? 'ভূমিকা' : 'Introduction',
      sub: widget.isBangla ? 'গ্রন্থের ভূমিকা' : 'Preface of the book',
    );
    final hadiths = widget.book.hadiths.asMap().entries.map((e) {
      final h = e.value;
      return _JumpItem(
        index: e.key,
        arabic: h.arabic.split('\n').first,
        label: '${widget.isBangla ? 'হাদিস' : 'Hadith'} ${h.id}',
        sub: widget.isBangla
            ? h.bangla.split('\n').first
            : h.english.split('\n').first,
      );
    }).toList();
    return [intro, ...hadiths];
  }

  List<_JumpItem> get _filtered {
    if (_query.isEmpty) return _allItems;
    final q = _query.toLowerCase();
    return _allItems.where((item) {
      return item.label.toLowerCase().contains(q) ||
          item.sub.toLowerCase().contains(q) ||
          item.arabic.contains(q) ||
          (item.index >= 0 &&
              '${widget.book.hadiths[item.index].id}'.contains(q));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final bottomPad =
        MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      decoration: BoxDecoration(
        color: widget.cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: MyColors.secondary.withOpacity(0.2), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withOpacity(0.3),
            blurRadius: 32,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: widget.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [MyColors.secondary, MyColors.primaryLight],
                    ),
                  ),
                  child: const Icon(
                    Icons.format_list_numbered_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.isBangla ? 'হাদিসে যান' : 'Jump to Hadith',
                  style: text.hadithJumpTitle.copyWith(color: widget.textMain),
                ),
                const Spacer(),
                Text(
                  '${widget.book.hadiths.length} hadiths',
                  style: text.hadithJumpCount.copyWith(color: widget.textHint),
                ),
              ],
            ),
          ),

          // Search field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: TextField(
              controller: widget.controller,
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              style: text.hadithJumpSearch.copyWith(color: widget.textMain),
              decoration: InputDecoration(
                hintText: widget.isBangla
                    ? 'নম্বর বা কীওয়ার্ড দিয়ে খুঁজুন...'
                    : 'Search by number or keyword...',
                hintStyle: text.hadithJumpSearchHint.copyWith(
                  color: widget.textHint,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: MyColors.secondary,
                  size: 20,
                ),
                filled: true,
                fillColor: widget.isDark
                    ? MyColors.darkSurface.withOpacity(0.6)
                    : MyColors.divider.withOpacity(0.25),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: MyColors.secondary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          Divider(height: 1, color: widget.divider),

          // List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 8, bottom: bottomPad + 16),
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final item = _filtered[i];
                return _JumpListTile(
                  item: item,
                  isBangla: widget.isBangla,
                  isDark: widget.isDark,
                  textMain: widget.textMain,
                  textHint: widget.textHint,
                  divider: widget.divider,
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onJump(item.index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _JumpItem {
  final int index; // -1 = intro
  final String arabic;
  final String label;
  final String sub;
  const _JumpItem({
    required this.index,
    required this.arabic,
    required this.label,
    required this.sub,
  });
}

class _JumpListTile extends StatelessWidget {
  final _JumpItem item;
  final bool isBangla, isDark;
  final Color textMain, textHint, divider;
  final VoidCallback onTap;

  const _JumpListTile({
    required this.item,
    required this.isBangla,
    required this.isDark,
    required this.textMain,
    required this.textHint,
    required this.divider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final isIntro = item.index == -1;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Badge
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: isIntro
                    ? MyColors.secondary.withOpacity(0.1)
                    : MyColors.primaryLight.withOpacity(0.1),
                border: Border.all(
                  color: isIntro
                      ? MyColors.secondary.withOpacity(0.25)
                      : MyColors.primaryLight.withOpacity(0.2),
                  width: 0.8,
                ),
              ),
              alignment: Alignment.center,
              child: isIntro
                  ? Icon(
                      Icons.menu_book_rounded,
                      size: 16,
                      color: MyColors.secondary,
                    )
                  : Text(
                      '${item.index + 1}',
                      style: text.hadithJumpNumber.copyWith(
                        color: MyColors.primaryLight,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.arabic,
                    textDirection: ui.TextDirection.rtl,
                    style: text.hadithJumpArabic.copyWith(color: textMain),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.sub,
                    style: text.hadithJumpSubtitle.copyWith(color: textHint),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, size: 12, color: textHint),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE COMPONENTS
// ─────────────────────────────────────────────────────────────────────────────

/// Pill-shaped language toggle

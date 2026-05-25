part of '../../../../views/dashboard/hadith/hadith_forty_short_view.dart';
class _JumpSheet extends StatefulWidget {
  final ShortHadithBook book;
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

  List<ShortHadith> get _filtered {
    if (_query.isEmpty) return widget.book.hadiths;
    final q = _query.toLowerCase();
    return widget.book.hadiths.where((h) {
      final id = '${h.id}';
      final eng = h.english.toLowerCase();
      final ban = h.bangla;
      return id.contains(q) || eng.contains(q) || ban.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad =
        MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: BoxDecoration(
        color: widget.cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: MyColors.tertiary.withOpacity(0.2), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withOpacity(0.25),
            blurRadius: 32,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle
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
                      colors: [MyColors.tertiary, MyColors.tertiaryLight],
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
                  style: GoogleFonts.sora(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: widget.textMain,
                  ),
                ),
                const Spacer(),
                Text(
                  '${widget.book.hadiths.length} hadiths',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: widget.textHint,
                  ),
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
              style: GoogleFonts.manrope(fontSize: 14, color: widget.textMain),
              decoration: InputDecoration(
                hintText: widget.isBangla
                    ? 'নম্বর বা কীওয়ার্ড দিয়ে খুঁজুন...'
                    : 'Search by number or keyword...',
                hintStyle: GoogleFonts.manrope(
                  fontSize: 13,
                  color: widget.textHint,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: MyColors.tertiary,
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
                    color: MyColors.tertiary,
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
                final h = _filtered[i];
                final idx = widget.book.hadiths.indexOf(h);
                return _JumpListTile(
                  hadith: h,
                  isBangla: widget.isBangla,
                  isDark: widget.isDark,
                  textMain: widget.textMain,
                  textHint: widget.textHint,
                  divider: widget.divider,
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onJump(idx);
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

class _JumpListTile extends StatelessWidget {
  final ShortHadith hadith;
  final bool isBangla, isDark;
  final Color textMain, textHint, divider;
  final VoidCallback onTap;

  const _JumpListTile({
    required this.hadith,
    required this.isBangla,
    required this.isDark,
    required this.textMain,
    required this.textHint,
    required this.divider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final headline = hadith.headlineOf(isBangla);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Number badge
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: MyColors.tertiary.withOpacity(0.1),
                border: Border.all(
                  color: MyColors.tertiary.withOpacity(0.25),
                  width: 0.8,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '${hadith.id}',
                style: GoogleFonts.sora(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: MyColors.tertiary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hadith.arabic,
                    textDirection: ui.TextDirection.rtl,
                    style: GoogleFonts.amiri(
                      fontSize: 15,
                      color: textMain,
                      height: 1.4,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    headline,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: textHint,
                      fontWeight: FontWeight.w500,
                    ),
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
// DOT ROW INDICATOR
// ─────────────────────────────────────────────────────────────────────────────


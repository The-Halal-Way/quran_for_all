import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────────────────────────────────────

enum DuahSituation {
  all,
  distress,
  forgiveness,
  guidance,
  provision,
  protection,
  family,
  knowledge,
}

class PowerfulDuah {
  const PowerfulDuah({
    required this.number,
    required this.title,
    required this.arabic,
    required this.pronunciation,
    required this.translation,
    required this.situations,
    this.source,
    this.isFeatured = false,
  });

  final int number;
  final String title;
  final String arabic;
  final String pronunciation;
  final String translation;
  final List<DuahSituation> situations;
  final String? source;
  final bool isFeatured; // top-5 "start with these" picks
}

// ─────────────────────────────────────────────────────────────────────────────
// DATA
// ─────────────────────────────────────────────────────────────────────────────

class PowerfulDuahData {
  static const List<PowerfulDuah> all = [
    PowerfulDuah(
      number: 1,
      title: 'Goodness in this life and the next',
      arabic:
          'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
      pronunciation:
          'Rabbanā ātinā fid-dunyā ḥasanah wa fil-ākhirati ḥasanah wa qinā ʿadhāban-nār',
      translation:
          'Our Lord, give us good in this world and good in the Hereafter, and protect us from the punishment of the Fire.',
      situations: [DuahSituation.all, DuahSituation.protection],
      source: 'Qur\'an 2:201',
      isFeatured: true,
    ),
    PowerfulDuah(
      number: 2,
      title: 'Forgiveness of all sins',
      arabic:
          'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ',
      pronunciation:
          'Rabbi-ghfir lī wa tub ʿalayya innaka antat-Tawwābur-Raḥīm',
      translation:
          'My Lord, forgive me and accept my repentance. Indeed, You are the Acceptor of repentance, the Most Merciful.',
      situations: [DuahSituation.all, DuahSituation.forgiveness],
      source: 'Hadith — Abu Dawud',
    ),
    PowerfulDuah(
      number: 3,
      title: 'Relief from anxiety & grief',
      arabic:
          'اللَّهُمَّ إِنِّي عَبْدُكَ، ابْنُ عَبْدِكَ، ابْنُ أَمَتِكَ، نَاصِيَتِي بِيَدِكَ، مَاضٍ فِيَّ حُكْمُكَ، عَدْلٌ فِيَّ قَضَاؤُكَ، أَسْأَلُكَ بِكُلِّ اسْمٍ هُوَ لَكَ، سَمَّيْتَ بِهِ نَفْسَكَ، أَوْ أَنْزَلْتَهُ فِي كِتَابِكَ، أَوْ عَلَّمْتَهُ أَحَدًا مِنْ خَلْقِكَ، أَوِ اسْتَأْثَرْتَ بِهِ فِي عِلْمِ الْغَيْبِ عِنْدَكَ، أَنْ تَجْعَلَ الْقُرْآنَ رَبِيعَ قَلْبِي، وَنُورَ صَدْرِي، وَجَلَاءَ حُزْنِي، وَذَهَابَ هَمِّي',
      pronunciation:
          'Allāhumma innī ʿabduka, ibnu ʿabdika, ibnu amatika, nāṣiyatī biyadika, māḍin fiyya ḥukmuka, ʿadlun fiyya qaḍā\'uka... an tajʿalal-Qur\'āna rabīʿa qalbī, wa nūra ṣadrī, wa jalā\'a ḥuznī, wa dhahāba hammī',
      translation:
          'O Allah, I am Your servant, son of Your servant, son of Your maidservant. My forelock is in Your hand... make the Qur\'an the spring of my heart, the light of my chest, the remover of my sadness, and the reliever of my distress.',
      situations: [DuahSituation.all, DuahSituation.distress],
      source: 'Hadith — Ahmad',
    ),
    PowerfulDuah(
      number: 4,
      title: 'Relief from debt & poverty',
      arabic:
          'اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ، وَأَغْنِنِي بِفَضْلِكَ عَمَّنْ سِوَاكَ',
      pronunciation:
          'Allāhumma-kfinī biḥalālika ʿan ḥarāmika wa aghninī bifaḍlika ʿamman siwāk',
      translation:
          'O Allah, suffice me with what You have made lawful instead of what You have made unlawful, and make me independent by Your bounty from needing anyone besides You.',
      situations: [DuahSituation.all, DuahSituation.provision],
      source: 'Hadith — Tirmidhi',
    ),
    PowerfulDuah(
      number: 5,
      title: 'Increase in knowledge & wisdom',
      arabic: 'رَبِّ زِدْنِي عِلْمًا',
      pronunciation: 'Rabbi zidnī ʿilmā',
      translation: 'My Lord, increase me in knowledge.',
      situations: [DuahSituation.all, DuahSituation.knowledge],
      source: 'Qur\'an 20:114',
      isFeatured: true,
    ),
    PowerfulDuah(
      number: 6,
      title: 'Steadfastness of the heart',
      arabic: 'يَا مُقَلِّبَ الْقُلُوبِ ثَبِّتْ قَلْبِي عَلَى دِينِكَ',
      pronunciation: 'Yā Muqallibal-qulūb, thabbit qalbī ʿalā dīnik',
      translation:
          'O Turner of the hearts, keep my heart firm upon Your religion.',
      situations: [DuahSituation.all, DuahSituation.guidance],
      source: 'Hadith — Tirmidhi',
      isFeatured: true,
    ),
    PowerfulDuah(
      number: 7,
      title: 'Guidance and righteousness',
      arabic: 'اللَّهُمَّ اهْدِنِي وَسَدِّدْنِي',
      pronunciation: 'Allāhumma-hdinī wa saddidnī',
      translation: 'O Allah, guide me and keep me firm and correct.',
      situations: [DuahSituation.all, DuahSituation.guidance],
      source: 'Hadith — Muslim',
    ),
    PowerfulDuah(
      number: 8,
      title: 'Protection from worry & laziness',
      arabic:
          'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الهَمِّ وَالحَزَنِ، وَالعَجْزِ وَالكَسَلِ، وَالجُبْنِ وَالبُخْلِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ',
      pronunciation:
          'Allāhumma innī aʿūdhu bika minal-hammi wal-ḥazan, wal-ʿajzi wal-kasal, wal-jubni wal-bukhl, wa ḍalaʿid-dayni wa ghalabatir-rijāl',
      translation:
          'O Allah, I seek refuge in You from worry and grief, weakness and laziness, cowardice and stinginess, the burden of debt, and being overpowered by people.',
      situations: [
        DuahSituation.all,
        DuahSituation.distress,
        DuahSituation.protection
      ],
      source: 'Hadith — Bukhari',
      isFeatured: true,
    ),
    PowerfulDuah(
      number: 9,
      title: 'Acceptance of good deeds',
      arabic:
          'رَبَّنَا تَقَبَّلْ مِنَّا إِنَّكَ أَنْتَ السَّمِيعُ العَلِيمُ',
      pronunciation:
          'Rabbanā taqabbal minnā innaka Antas-Samīʿul-ʿAlīm',
      translation:
          'Our Lord, accept from us. Indeed, You are the All-Hearing, the All-Knowing.',
      situations: [DuahSituation.all],
      source: 'Qur\'an 2:127',
    ),
    PowerfulDuah(
      number: 10,
      title: 'Mercy and right guidance',
      arabic:
          'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِنْ لَدُنْكَ رَحْمَةً ۚ إِنَّكَ أَنْتَ الْوَهَّابُ',
      pronunciation:
          'Rabbanā lā tuzigh qulūbanā baʿda idh hadaytanā wa hab lanā min ladunka raḥmah, innaka antal-Wahhāb',
      translation:
          'Our Lord, do not let our hearts deviate after You have guided us, and grant us mercy from Yourself. Indeed, You are the Bestower.',
      situations: [DuahSituation.all, DuahSituation.guidance],
      source: 'Qur\'an 3:8',
    ),
    PowerfulDuah(
      number: 11,
      title: 'Patience and a good ending',
      arabic:
          'رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَتَوَفَّنَا مُسْلِمِينَ',
      pronunciation:
          'Rabbanā afrigh ʿalaynā ṣabran wa tawaffanā muslimīn',
      translation:
          'Our Lord, pour upon us patience and let us die as Muslims.',
      situations: [DuahSituation.all, DuahSituation.distress],
      source: 'Qur\'an 7:126',
    ),
    PowerfulDuah(
      number: 12,
      title: 'Righteous family & pure heart',
      arabic:
          'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا',
      pronunciation:
          'Rabbanā hab lanā min azwājinā wa dhurriyyātinā qurrata aʿyunin wajʿalnā lil-muttaqīna imāmā',
      translation:
          'Our Lord, grant us from our spouses and children comfort to our eyes and make us leaders for the righteous.',
      situations: [DuahSituation.all, DuahSituation.family],
      source: 'Qur\'an 25:74',
    ),
    PowerfulDuah(
      number: 13,
      title: 'Ease in difficult tasks',
      arabic:
          'رَبِّ اشْرَحْ لِي صَدْرِي ۝ وَيَسِّرْ لِي أَمْرِي ۝ وَاحْلُلْ عُقْدَةً مِنْ لِسَانِي ۝ يَفْقَهُوا قَوْلِي',
      pronunciation:
          'Rabbi-shraḥ lī ṣadrī, wa yassir lī amrī, waḥlul ʿuqdatan min lisānī, yafqahū qawlī',
      translation:
          'My Lord, expand for me my chest, ease for me my task, and untie the knot from my tongue so that they may understand my speech.',
      situations: [DuahSituation.all, DuahSituation.distress],
      source: 'Qur\'an 20:25–28',
    ),
    PowerfulDuah(
      number: 14,
      title: 'Protection from all evil',
      arabic: 'حَسْبُنَا اللَّهُ وَنِعْمَ الوَكِيلُ',
      pronunciation: 'Ḥasbunallāhu wa niʿmal-wakīl',
      translation:
          'Allah is sufficient for us, and He is the best disposer of affairs.',
      situations: [DuahSituation.all, DuahSituation.protection],
      source: 'Qur\'an 3:173',
    ),
    PowerfulDuah(
      number: 15,
      title: 'Du\'ā of Yunus ﷺ',
      arabic:
          'لَا إِلٰهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
      pronunciation:
          'Lā ilāha illā anta subḥānaka innī kuntu minaẓ-ẓālimīn',
      translation:
          'There is no god except You. Glory be to You. Indeed, I was among the wrongdoers.',
      situations: [
        DuahSituation.all,
        DuahSituation.distress,
        DuahSituation.forgiveness
      ],
      source: 'Qur\'an 21:87',
      isFeatured: true,
    ),
    PowerfulDuah(
      number: 16,
      title: 'Sayyidul Istigḥfār',
      arabic:
          'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلٰهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي، فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
      pronunciation:
          'Allāhumma anta rabbī lā ilāha illā anta, khalaqtanī wa anā ʿabduka, wa anā ʿalā ʿahdika wa waʿdika mastaṭaʿtu... faghfir lī fa innahu lā yaghfirudh-dhunūba illā anta',
      translation:
          'O Allah, You are my Lord. There is no god except You. You created me and I am Your servant... so forgive me, for none forgives sins except You.',
      situations: [DuahSituation.all, DuahSituation.forgiveness],
      source: 'Hadith — Bukhari',
    ),
  ];

  static List<PowerfulDuah> filtered(DuahSituation situation) {
    if (situation == DuahSituation.all) return all;
    return all.where((d) => d.situations.contains(situation)).toList();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SITUATION META
// ─────────────────────────────────────────────────────────────────────────────

extension SituationMeta on DuahSituation {
  String get label {
    switch (this) {
      case DuahSituation.all:
        return 'All';
      case DuahSituation.distress:
        return 'Distress';
      case DuahSituation.forgiveness:
        return 'Forgiveness';
      case DuahSituation.guidance:
        return 'Guidance';
      case DuahSituation.provision:
        return 'Provision';
      case DuahSituation.protection:
        return 'Protection';
      case DuahSituation.family:
        return 'Family';
      case DuahSituation.knowledge:
        return 'Knowledge';
    }
  }

  IconData get icon {
    switch (this) {
      case DuahSituation.all:
        return Icons.apps_rounded;
      case DuahSituation.distress:
        return Icons.favorite_border_rounded;
      case DuahSituation.forgiveness:
        return Icons.wb_sunny_rounded;
      case DuahSituation.guidance:
        return Icons.explore_rounded;
      case DuahSituation.provision:
        return Icons.spa_rounded;
      case DuahSituation.protection:
        return Icons.shield_rounded;
      case DuahSituation.family:
        return Icons.people_rounded;
      case DuahSituation.knowledge:
        return Icons.auto_stories_rounded;
    }
  }

  Color get color {
    switch (this) {
      case DuahSituation.all:
        return const Color(0xFF4B30A1);
      case DuahSituation.distress:
        return const Color(0xFFD50057);
      case DuahSituation.forgiveness:
        return const Color(0xFF00BFA5);
      case DuahSituation.guidance:
        return const Color(0xFF4B30A1);
      case DuahSituation.provision:
        return const Color(0xFF00897B);
      case DuahSituation.protection:
        return const Color(0xFF8E0033);
      case DuahSituation.family:
        return const Color(0xFFFF4081);
      case DuahSituation.knowledge:
        return const Color(0xFF448AFF);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────────────────────────────────────

class PowerfulDuahView extends StatefulWidget {
  const PowerfulDuahView({super.key});

  @override
  State<PowerfulDuahView> createState() => _PowerfulDuahViewState();
}

class _PowerfulDuahViewState extends State<PowerfulDuahView>
    with SingleTickerProviderStateMixin {
  DuahSituation _selected = DuahSituation.all;
  bool _featuredOnly = false;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 240));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _switch(DuahSituation s) {
    if (_selected == s) return;
    _fadeCtrl.reverse().then((_) {
      setState(() => _selected = s);
      _fadeCtrl.forward();
    });
  }

  List<PowerfulDuah> get _filtered {
    var list = PowerfulDuahData.filtered(_selected);
    if (_featuredOnly) list = list.where((d) => d.isFeatured).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF060118) : const Color(0xFFF5F2FF),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ──────────────────────────────────────────────────────
          _PowerfulAppBar(isDark: isDark),

          // ── Important note banner ────────────────────────────────────────
          SliverToBoxAdapter(
            child: _NoteBanner(isDark: isDark),
          ),

          // ── Filter chips ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _FilterRow(
              selected: _selected,
              featuredOnly: _featuredOnly,
              isDark: isDark,
              onSituationChanged: _switch,
              onFeaturedToggled: () =>
                  setState(() => _featuredOnly = !_featuredOnly),
            ),
          ),

          // ── Count bar ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _CountBar(
              count: _filtered.length,
              total: PowerfulDuahData.all.length,
              situation: _selected,
              isDark: isDark,
            ),
          ),

          // ── Duah list ────────────────────────────────────────────────────
          SliverFadeTransition(
            opacity: _fadeAnim,
            sliver: SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => _PowerfulDuahCard(
                    duah: _filtered[i],
                    isDark: isDark,
                    situationColor: _selected.color,
                  ),
                  childCount: _filtered.length,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// APP BAR
// ─────────────────────────────────────────────────────────────────────────────

class _PowerfulAppBar extends StatelessWidget {
  const _PowerfulAppBar({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textPrimary =
        isDark ? const Color(0xFFEDE7F6) : const Color(0xFF120B24);
    final textSecondary =
        isDark ? const Color(0xFF7E57C2) : const Color(0xFF7A7288);

    return SliverAppBar(
      pinned: true,
      expandedHeight: 160,
      collapsedHeight: 64,
      backgroundColor:
          isDark ? const Color(0xFF060118) : const Color(0xFFF5F2FF),
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded,
            color: textPrimary, size: 20),
        onPressed: () => Navigator.maybePop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 36), // account for leading
            Text(
              'Powerful Du\'ās',
              style: theme.textTheme.titleLarge?.copyWith(color: textPrimary),
            ),
          ],
        ),
        background: Padding(
          padding: const EdgeInsets.fromLTRB(20, 72, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Decorative Arabic header
              Text(
                'أَدْعِيَة قُرْآنِيَّة وَنَبَوِيَّة',
                textDirection: TextDirection.rtl,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontFamily: 'Scheherazade New',
                  fontSize: 22,
                  color: const Color(0xFF4B30A1).withValues(alpha: 0.6),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Qur\'ānic & Prophetic supplications',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: textSecondary,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// IMPORTANT NOTE BANNER
// ─────────────────────────────────────────────────────────────────────────────

class _NoteBanner extends StatefulWidget {
  const _NoteBanner({required this.isDark});
  final bool isDark;

  @override
  State<_NoteBanner> createState() => _NoteBannerState();
}

class _NoteBannerState extends State<_NoteBanner> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return AnimatedSize(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      child: _dismissed
          ? const SizedBox.shrink()
          : Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4B30A1).withValues(
                        alpha: widget.isDark ? 0.18 : 0.08),
                    const Color(0xFF00BFA5).withValues(
                        alpha: widget.isDark ? 0.10 : 0.04),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF4B30A1).withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4B30A1).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Color(0xFF4B30A1),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Important note',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: const Color(0xFF4B30A1),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Du\'ā is answered in the way Allah wills, at the time He wills, and in the form He wills. These are authentic and deeply beloved supplications from Qur\'ānic and Prophetic sources.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: widget.isDark
                                ? const Color(0xFFB39DDB)
                                : const Color(0xFF4C425C),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _dismissed = true),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: widget.isDark
                          ? const Color(0xFF7E57C2)
                          : const Color(0xFF7A7288),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FILTER ROW
// ─────────────────────────────────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.selected,
    required this.featuredOnly,
    required this.isDark,
    required this.onSituationChanged,
    required this.onFeaturedToggled,
  });

  final DuahSituation selected;
  final bool featuredOnly;
  final bool isDark;
  final ValueChanged<DuahSituation> onSituationChanged;
  final VoidCallback onFeaturedToggled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderC =
        isDark ? const Color(0xFF382E54) : const Color(0xFFD9D1E8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Best 5" toggle
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: GestureDetector(
            onTap: onFeaturedToggled,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: featuredOnly
                    ? const Color(0xFFD50057).withValues(alpha: 0.14)
                    : (isDark
                        ? const Color(0xFF1D1238)
                        : Colors.white),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: featuredOnly
                      ? const Color(0xFFD50057).withValues(alpha: 0.45)
                      : borderC,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 15,
                    color: featuredOnly
                        ? const Color(0xFFD50057)
                        : (isDark
                            ? const Color(0xFF7E57C2)
                            : const Color(0xFF7A7288)),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Best 5 to memorize first',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontSize: 12,
                      color: featuredOnly
                          ? const Color(0xFFD50057)
                          : (isDark
                              ? const Color(0xFFB39DDB)
                              : const Color(0xFF4C425C)),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Situation chips (horizontal scroll)
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: DuahSituation.values.map((s) {
              final isActive = selected == s;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => onSituationChanged(s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? s.color.withValues(alpha: isDark ? 0.20 : 0.12)
                          : (isDark
                              ? const Color(0xFF1D1238)
                              : Colors.white),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isActive
                            ? s.color.withValues(alpha: 0.50)
                            : borderC,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          s.icon,
                          size: 13,
                          color: isActive
                              ? s.color
                              : (isDark
                                  ? const Color(0xFF7E57C2)
                                  : const Color(0xFF7A7288)),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          s.label,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontSize: 12,
                            color: isActive
                                ? s.color
                                : (isDark
                                    ? const Color(0xFFB39DDB)
                                    : const Color(0xFF4C425C)),
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COUNT BAR
// ─────────────────────────────────────────────────────────────────────────────

class _CountBar extends StatelessWidget {
  const _CountBar({
    required this.count,
    required this.total,
    required this.situation,
    required this.isDark,
  });

  final int count;
  final int total;
  final DuahSituation situation;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 14,
            decoration: BoxDecoration(
              color: situation.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: theme.textTheme.titleMedium?.copyWith(
              fontFamily: 'Sora',
              color: situation.color,
              fontSize: 15,
            ),
          ),
          Text(
            ' du\'ās',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? const Color(0xFF7E57C2)
                  : const Color(0xFF7A7288),
            ),
          ),
          if (count < total) ...[
            Text(
              ' of $total',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? const Color(0xFF382E54)
                    : const Color(0xFFD9D1E8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// POWERFUL DUAH CARD
// ─────────────────────────────────────────────────────────────────────────────

class _PowerfulDuahCard extends StatefulWidget {
  const _PowerfulDuahCard({
    required this.duah,
    required this.isDark,
    required this.situationColor,
  });

  final PowerfulDuah duah;
  final bool isDark;
  final Color situationColor;

  @override
  State<_PowerfulDuahCard> createState() => _PowerfulDuahCardState();
}

class _PowerfulDuahCardState extends State<_PowerfulDuahCard> {
  bool _copied = false;
  bool _showPronunciation = true;

  void _copy() {
    Clipboard.setData(ClipboardData(
      text:
          '${widget.duah.arabic}\n\n${widget.duah.pronunciation}\n\n${widget.duah.translation}',
    ));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2),
        () => mounted ? setState(() => _copied = false) : null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final duah = widget.duah;
    final isDark = widget.isDark;

    final cardBg = isDark ? const Color(0xFF120A2B) : Colors.white;
    final borderC =
        isDark ? const Color(0xFF382E54) : const Color(0xFFD9D1E8);

    // Featured cards get a faint fuchsia top-border glow
    final featuredBorder = duah.isFeatured
        ? Border.all(
            color: const Color(0xFFD50057).withValues(alpha: 0.35),
          )
        : Border.all(color: borderC);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: featuredBorder,
        boxShadow: duah.isFeatured
            ? [
                BoxShadow(
                  color: const Color(0xFFD50057).withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header strip ─────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 10),
            decoration: BoxDecoration(
              color: (duah.isFeatured
                      ? const Color(0xFFD50057)
                      : const Color(0xFF4B30A1))
                  .withValues(alpha: isDark ? 0.10 : 0.05),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Number badge
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: (duah.isFeatured
                            ? const Color(0xFFD50057)
                            : const Color(0xFF4B30A1))
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${duah.number}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: duah.isFeatured
                          ? const Color(0xFFD50057)
                          : const Color(0xFF4B30A1),
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        duah.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontFamily: 'Sora',
                          fontSize: 14,
                          color: isDark
                              ? const Color(0xFFEDE7F6)
                              : const Color(0xFF120B24),
                        ),
                      ),
                      if (duah.source != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          duah.source!,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isDark
                                ? const Color(0xFF7E57C2)
                                : const Color(0xFF7A7288),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Featured star
                if (duah.isFeatured)
                  const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.star_rounded,
                      color: Color(0xFFD50057),
                      size: 16,
                    ),
                  ),
                // Situation tags
                ...duah.situations
                    .where((s) => s != DuahSituation.all)
                    .take(2)
                    .map(
                      (s) => Container(
                        margin: const EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: s.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(s.icon, size: 11, color: s.color),
                      ),
                    ),
              ],
            ),
          ),

          // ── Body ──────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Arabic
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E0A3C).withValues(
                        alpha: isDark ? 0.45 : 0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF4B30A1).withValues(
                          alpha: isDark ? 0.18 : 0.08),
                    ),
                  ),
                  child: Text(
                    duah.arabic,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontFamily: 'Scheherazade New',
                      fontSize: 22,
                      height: 2.0,
                      color: isDark
                          ? const Color(0xFFEDE7F6)
                          : const Color(0xFF120B24),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Pronunciation toggle
                GestureDetector(
                  onTap: () =>
                      setState(() => _showPronunciation = !_showPronunciation),
                  child: Row(
                    children: [
                      Container(
                        width: 3,
                        height: 13,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4B30A1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(
                        child: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 200),
                          crossFadeState: _showPronunciation
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: Text(
                            duah.pronunciation,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: isDark
                                  ? const Color(0xFFB39DDB)
                                  : const Color(0xFF4C425C),
                              height: 1.5,
                            ),
                          ),
                          secondChild: Text(
                            'Tap to show pronunciation',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? const Color(0xFF382E54)
                                  : const Color(0xFFD9D1E8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Translation
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 3,
                      height: 13,
                      margin: const EdgeInsets.only(right: 8, top: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BFA5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        duah.translation,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? const Color(0xFFEDE7F6)
                              : const Color(0xFF120B24),
                          height: 1.55,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Bottom action row
                Row(
                  children: [
                    // Situation tag pills
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: duah.situations
                            .where((s) => s != DuahSituation.all)
                            .map(
                              (s) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: s.color.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: s.color.withValues(alpha: 0.22),
                                  ),
                                ),
                                child: Text(
                                  s.label,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: s.color,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    // Copy button
                    GestureDetector(
                      onTap: _copy,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: _copied
                              ? const Color(0xFF00BFA5).withValues(alpha: 0.12)
                              : (isDark
                                  ? const Color(0xFF1D1238)
                                  : const Color(0xFFF5F2FF)),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _copied
                                ? const Color(0xFF00BFA5).withValues(alpha: 0.4)
                                : borderC,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _copied
                                  ? Icons.check_rounded
                                  : Icons.copy_rounded,
                              size: 14,
                              color: _copied
                                  ? const Color(0xFF00BFA5)
                                  : (isDark
                                      ? const Color(0xFF7E57C2)
                                      : const Color(0xFF7A7288)),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _copied ? 'Copied' : 'Copy',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: _copied
                                    ? const Color(0xFF00BFA5)
                                    : (isDark
                                        ? const Color(0xFF7E57C2)
                                        : const Color(0xFF7A7288)),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
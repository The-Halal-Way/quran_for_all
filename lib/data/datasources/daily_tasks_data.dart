import '../../core/enums/task_category.dart';
import '../models/daily_task_model.dart';

/// Static definitions of every Daily Tracker task, including the
/// Friday-only additions.
class DailyTasksData {
  const DailyTasksData._();

  /// Every day's checklist (Fard prayers, nafl, duas, sunnahs, Quran,
  /// tasbeeh and hadith). On Fridays the `dhuhr` entry is replaced by
  /// `jumuah` from [fridayOnlyTasks].
  static const List<DailyTask> standardTasks = [
    // ── Fard prayers ─────────────────────────────────────────────────────
    DailyTask(
      id: 'fajr',
      titleEn: 'Fajr (2 sunnah + 2 fard)',
      titleBn: 'ফজর নামাজ',
      category: TaskCategory.prayer,
    ),
    DailyTask(
      id: 'dhuhr',
      titleEn: 'Dhuhr (4 sunnah + 4 fard + 2 sunnah)',
      titleBn: 'যোহর নামাজ',
      category: TaskCategory.prayer,
    ),
    DailyTask(
      id: 'asr',
      titleEn: 'Asr (4 fard)',
      titleBn: 'আসর নামাজ',
      category: TaskCategory.prayer,
    ),
    DailyTask(
      id: 'maghrib',
      titleEn: 'Maghrib (3 fard + 2 sunnah)',
      titleBn: 'মাগরিব নামাজ',
      category: TaskCategory.prayer,
    ),
    DailyTask(
      id: 'isha',
      titleEn: 'Isha (4 fard + 2 sunnah + 3 witr)',
      titleBn: 'ইশা নামাজ',
      category: TaskCategory.prayer,
    ),

    // ── Nafl prayers (optional) ──────────────────────────────────────────
    DailyTask(
      id: 'tahajjud',
      titleEn: 'Tahajjud',
      titleBn: 'তাহাজ্জুদ',
      category: TaskCategory.nafl,
      isOptional: true,
    ),
    DailyTask(
      id: 'duha',
      titleEn: 'Duha / Chasht',
      titleBn: 'চাশতের নামাজ',
      category: TaskCategory.nafl,
      isOptional: true,
    ),
    DailyTask(
      id: 'awwabin',
      titleEn: 'Awwabin (after Maghrib)',
      titleBn: 'আওয়াবিন',
      category: TaskCategory.nafl,
      isOptional: true,
    ),

    // ── Daily duas ───────────────────────────────────────────────────────
    DailyTask(
      id: 'morning_azkar',
      titleEn: 'Morning Azkar (after Fajr)',
      titleBn: 'সকালের আযকার',
      category: TaskCategory.dua,
    ),
    DailyTask(
      id: 'evening_azkar',
      titleEn: 'Evening Azkar (after Asr)',
      titleBn: 'সন্ধ্যার আযকার',
      category: TaskCategory.dua,
    ),
    DailyTask(
      id: 'sleep_dua',
      titleEn: 'Sleep Dua',
      titleBn: 'ঘুমানোর দোয়া',
      category: TaskCategory.dua,
    ),
    DailyTask(
      id: 'waking_dua',
      titleEn: 'Waking Dua',
      titleBn: 'ঘুম থেকে উঠার দোয়া',
      category: TaskCategory.dua,
    ),

    // ── Sunnahs ──────────────────────────────────────────────────────────
    DailyTask(
      id: 'miswak',
      titleEn: 'Miswak',
      titleBn: 'মিসওয়াক করা',
      category: TaskCategory.sunnah,
    ),
    DailyTask(
      id: 'eat_right_hand',
      titleEn: 'Eat with right hand',
      titleBn: 'ডান হাতে খাওয়া',
      category: TaskCategory.sunnah,
    ),
    DailyTask(
      id: 'bismillah_before_eating',
      titleEn: 'Say Bismillah before eating',
      titleBn: 'খাওয়ার আগে বিসমিল্লাহ',
      category: TaskCategory.sunnah,
    ),
    DailyTask(
      id: 'alhamdulillah_after_eating',
      titleEn: 'Say Alhamdulillah after eating',
      titleBn: 'খাওয়ার পরে আলহামদুলিল্লাহ',
      category: TaskCategory.sunnah,
    ),

    // ── Quran ────────────────────────────────────────────────────────────
    DailyTask(
      id: 'quran_page',
      titleEn: 'Read at least 1 page of Quran',
      titleBn: 'কমপক্ষে ১ পাতা কোরআন তিলাওয়াত',
      category: TaskCategory.quran,
    ),

    // ── Tasbeeh ──────────────────────────────────────────────────────────
    DailyTask(
      id: 'tasbeeh_after_prayer',
      titleEn:
          'SubhanAllah 33x, Alhamdulillah 33x, AllahuAkbar 34x after each '
          'prayer',
      titleBn: 'তাসবিহ পাঠ',
      category: TaskCategory.tasbeeh,
    ),

    // ── Hadith ───────────────────────────────────────────────────────────
    DailyTask(
      id: 'daily_hadith',
      titleEn: 'Read at least 1 hadith (Forty Hadith / An-Nawawi)',
      titleBn: 'দৈনিক একটি হাদিস',
      category: TaskCategory.hadith,
    ),
  ];

  /// Tasks added on Fridays. `jumuah` replaces `dhuhr` from
  /// [standardTasks]; the rest are appended to the routine.
  static const List<DailyTask> fridayOnlyTasks = [
    DailyTask(
      id: 'jumuah',
      titleEn: "Jumu'ah Prayer",
      titleBn: 'জুমার নামাজ',
      category: TaskCategory.prayer,
      isFridayOnly: true,
    ),
    DailyTask(
      id: 'surah_kahf',
      titleEn: 'Surah Al-Kahf recitation',
      titleBn: 'সূরা কাহফ তিলাওয়াত',
      category: TaskCategory.quran,
      isFridayOnly: true,
    ),
    DailyTask(
      id: 'extra_durood',
      titleEn: 'Extra durood on Prophet ﷺ',
      titleBn: 'বেশি বেশি দরুদ পাঠ',
      category: TaskCategory.dua,
      isFridayOnly: true,
    ),
    DailyTask(
      id: 'friday_ghusl',
      titleEn: 'Friday Sunnah Ghusl',
      titleBn: 'জুমার গোসল',
      category: TaskCategory.sunnah,
      isFridayOnly: true,
    ),
    DailyTask(
      id: 'ittar',
      titleEn: 'Use perfume/ittar',
      titleBn: 'আতর ব্যবহার',
      category: TaskCategory.sunnah,
      isFridayOnly: true,
    ),
  ];

  /// Builds the full checklist for [date], applying the Friday rules:
  /// `jumuah` replaces `dhuhr` and the remaining Friday-only tasks are
  /// appended to the standard list.
  static List<DailyTask> tasksForDate(DateTime date) {
    final isFriday = date.weekday == DateTime.friday;

    final tasks = <DailyTask>[
      for (final task in standardTasks)
        if (!isFriday || task.id != 'dhuhr') task,
    ];

    if (isFriday) {
      tasks.addAll(fridayOnlyTasks);
    }

    return tasks;
  }
}

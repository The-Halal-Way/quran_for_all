/// Identifies which section of the app originated the current audio playback.
enum PlaybackSource {
  /// No audio is playing, or the source page is not tracked.
  none,

  /// Audio was started from [SurahDetailsView] (Read Quran section).
  surahDetails,

  /// Audio was started from [LearningModuleDetailView] (Learn Quran section).
  lessonDetail,
}

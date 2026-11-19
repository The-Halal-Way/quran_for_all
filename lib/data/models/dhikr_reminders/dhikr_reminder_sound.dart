enum DhikrReminderSound {
  arRahman('aarahman_notification'),
  allahHu('allah_hu_allah_hu_notification'),
  allahumma('allah_humma_notification'),
  islamSpecial('islam_special_notification'),
  islamic('islamic_notification'),
  islamicRingtone('islamic_ringtone_notification'),
  muhammad('muhammad_notification'),
  quran('quran_notification'),
  rahman('rahman_notification'),
  ramadan('ramadan_sms_notification'),
  weddingNasheed('wedding_nasheed_notification');

  const DhikrReminderSound(this.resource);
  final String resource;
  String get filename => '$resource.wav';
  String get assetPath => 'audio/reminders/$filename';

  static DhikrReminderSound parse(Object? value) => switch (value) {
    // Preserve old reminder settings while replacing the removed demo tones.
    'glass' => arRahman,
    'bell' => ramadan,
    'chime' => rahman,
    _ => values.where((sound) => sound.name == value).firstOrNull ?? arRahman,
  };
}

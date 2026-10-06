class NuraniQuranDocument {
  const NuraniQuranDocument._();

  static const fileId = '1dCZFwhF-VoXmVcfEzJzWx-dfhEx2Bs-2';
  static const fileName = 'nurani_quran.pdf';
  static const expectedBytes = 14102722;
  static const maximumBytes = 50 * 1024 * 1024;
  static const preferencesKey = 'nurani_quran_reading_$fileId';

  static final downloadUri = Uri.https(
    'drive.usercontent.google.com',
    '/download',
    {'id': fileId, 'export': 'download', 'confirm': 't'},
  );
}

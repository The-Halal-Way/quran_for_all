import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/core/utils/string_utils.dart';

void main() {
  test('normalizes Uthmani marks and common alef and ya forms', () {
    expect(StringUtils.normalizeArabicForSearch('ٱلْحَمْدُ'), 'الحمد');
    expect(StringUtils.normalizeArabicForSearch('إِيَّاكَ'), 'اياك');
    expect(StringUtils.normalizeArabicForSearch('عَلَىٰ'), 'علي');
    expect(StringUtils.normalizeArabicForSearch('آمَنُوا۟'), 'امنوا');
  });

  test('builds safe FTS tokens from Arabic, English and Bangla', () {
    expect(StringUtils.sanitizeFtsQuery('الْحَمْدُ'), 'الحمد*');
    expect(StringUtils.sanitizeFtsQuery('إِيَّاكَ عَلَىٰ'), 'اياك* علي*');
    expect(
      StringUtils.sanitizeFtsQuery('Mercy and peace'),
      'mercy* and* peace*',
    );
    expect(StringUtils.sanitizeFtsQuery('আলহামদুলিল্লাহ'), 'আলহামদুলিল্লাহ*');
    expect(StringUtils.sanitizeFtsQuery('" OR *'), 'or*');
  });
}

import 'data/charity_amals.dart';
import 'data/dhikr_amals.dart';
import 'data/dua_amals.dart';
import 'data/quran_amals.dart';
import 'data/salah_amals.dart';
import 'data/special_time_amals.dart';
import 'need_amal.dart';

/// Kept in category order for browsing and search.
const needAmals = <NeedAmal>[
  ...quranAmals,
  ...salahAmals,
  ...dhikrAmals,
  ...duaAmals,
  ...charityAmals,
  ...specialTimeAmals,
];

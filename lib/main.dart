import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // All app fonts are bundled; opening the dashboard must not fetch fonts.
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const QuranForAllApp());
}

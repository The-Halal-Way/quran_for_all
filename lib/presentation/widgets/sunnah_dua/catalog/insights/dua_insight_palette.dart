import 'package:flutter/material.dart';

/// Deep enough for prose on light surfaces, softly lit in dark appearance.
Color duaInsightAccent(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFA3E2CE)
    : const Color(0xFF245D52);

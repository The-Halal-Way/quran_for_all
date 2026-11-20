import 'package:flutter/material.dart';

class RuqyahStyle {
  const RuqyahStyle._();
  static const teal = Color(0xFF168F78);
  static const deep = Color(0xFF07564F);
  static Color accent(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF7DDAC3)
      : const Color(0xFF087561);
  static String number(BuildContext context, int value) {
    final raw = '$value';
    if (Localizations.localeOf(context).languageCode != 'bn') return raw;
    const digits = '০১২৩৪৫৬৭৮৯';
    return raw.split('').map((s) {
      final digit = int.tryParse(s);
      return digit == null ? s : digits[digit];
    }).join();
  }
}

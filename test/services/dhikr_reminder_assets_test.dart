import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/data/models/dhikr_reminders/dhikr_reminder_sound.dart';

void main() {
  test(
    'all eleven preview sounds are complete PCM WAVs with identical native resources',
    () {
      expect(DhikrReminderSound.values, hasLength(11));
      final project = File(
        'ios/Runner.xcodeproj/project.pbxproj',
      ).readAsStringSync();
      final keep = File(
        'android/app/src/main/res/raw/keep.xml',
      ).readAsStringSync();
      for (final sound in DhikrReminderSound.values) {
        final bytes = File('assets/${sound.assetPath}').readAsBytesSync();
        expect(ascii.decode(bytes.sublist(0, 4)), 'RIFF');
        expect(ascii.decode(bytes.sublist(8, 12)), 'WAVE');
        final data = ByteData.sublistView(bytes);
        expect(data.getUint32(4, Endian.little) + 8, bytes.length);
        int? byteRate, audioBytes;
        for (var offset = 12; offset + 8 <= bytes.length;) {
          final name = ascii.decode(bytes.sublist(offset, offset + 4));
          final length = data.getUint32(offset + 4, Endian.little);
          expect(offset + 8 + length, lessThanOrEqualTo(bytes.length));
          if (name == 'fmt ') {
            expect(data.getUint16(offset + 8, Endian.little), 1);
            expect(data.getUint16(offset + 10, Endian.little), 1);
            expect(data.getUint16(offset + 22, Endian.little), 16);
            byteRate = data.getUint32(offset + 16, Endian.little);
          } else if (name == 'data') {
            audioBytes = length;
          }
          offset += 8 + length + length % 2;
        }
        expect(
          audioBytes! / byteRate!,
          inExclusiveRange(0, 30),
          reason: sound.filename,
        );
        for (final folder in [
          'android/app/src/main/res/raw',
          'ios/Runner/ReminderSounds',
        ]) {
          expect(
            listEquals(
              bytes,
              File('$folder/${sound.filename}').readAsBytesSync(),
            ),
            true,
            reason: '$folder/${sound.filename}',
          );
        }
        expect(project, contains('path = ReminderSounds/${sound.filename};'));
        expect(project, contains('/* ${sound.filename} in Resources */,'));
        expect(keep, contains('@raw/${sound.resource}'));
      }
    },
  );
}

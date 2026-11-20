import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Only called from an explicit play/download action, never app startup.
class RuqyahAudioCache {
  RuqyahAudioCache({
    http.Client? client,
    Future<Directory> Function()? directory,
  }) : _client = client ?? http.Client(),
       _directory = directory;
  final http.Client _client;
  final Future<Directory> Function()? _directory;
  static const baseUrl =
      'https://cdn.islamic.network/quran/audio/128/ar.alafasy';

  String url(int verse) {
    if (verse < 1 || verse > 6236) throw ArgumentError.value(verse);
    return '$baseUrl/$verse.mp3';
  }

  Future<File> _file(int verse) async {
    url(verse);
    final directory = _directory != null
        ? await _directory()
        : Directory(
            path.join(
              (await getApplicationSupportDirectory()).path,
              'ruqyah_audio',
              'ar.alafasy',
            ),
          );
    await directory.create(recursive: true);
    return File(path.join(directory.path, '$verse.mp3'));
  }

  static bool _audioHeader(List<int> bytes) =>
      bytes.length >= 3 &&
      ((bytes[0] == 0x49 && bytes[1] == 0x44 && bytes[2] == 0x33) ||
          (bytes[0] == 0xff && (bytes[1] & 0xe0) == 0xe0));

  Future<String?> localPath(int verse) async {
    final file = await _file(verse);
    if (!await file.exists() || await file.length() < 128) return null;
    final handle = await file.open();
    try {
      return _audioHeader(await handle.read(3)) ? file.path : null;
    } finally {
      await handle.close();
    }
  }

  Future<bool> isDownloaded(List<int> verses) async {
    if (verses.isEmpty) return false;
    for (final verse in verses) {
      if (await localPath(verse) == null) return false;
    }
    return true;
  }

  Future<void> download(
    List<int> verses,
    void Function(double) onProgress,
  ) async {
    for (var index = 0; index < verses.length; index++) {
      final verse = verses[index];
      if (await localPath(verse) != null) {
        onProgress((index + 1) / verses.length);
        continue;
      }
      final file = await _file(verse);
      final temporary = File(
        '${file.path}.${DateTime.now().microsecondsSinceEpoch}.part',
      );
      final response = await _client
          .send(http.Request('GET', Uri.parse(url(verse))))
          .timeout(const Duration(seconds: 25));
      final type = response.headers['content-type'] ?? '';
      if (response.statusCode != 200 ||
          type.contains('text/') ||
          type.contains('application/json')) {
        await response.stream.listen((_) {}).cancel();
        throw const HttpException('Audio response unavailable.');
      }
      final sink = temporary.openWrite();
      var received = 0;
      final header = <int>[];
      var closed = false;
      try {
        await for (final chunk in response.stream.timeout(
          const Duration(seconds: 25),
        )) {
          if (header.length < 3) header.addAll(chunk.take(3 - header.length));
          received += chunk.length;
          if (received > 20 * 1024 * 1024) {
            throw const FormatException('Audio too large.');
          }
          sink.add(chunk);
          final total = response.contentLength;
          if (total != null && total > 0) {
            onProgress((index + received / total) / verses.length);
          }
        }
        await sink.flush();
        await sink.close();
        closed = true;
        if (received < 128 ||
            !_audioHeader(header) ||
            (response.contentLength != null &&
                received != response.contentLength)) {
          throw const FormatException('Incomplete audio download.');
        }
        await temporary.rename(file.path);
      } catch (_) {
        if (!closed) await sink.close();
        if (await temporary.exists()) await temporary.delete();
        rethrow;
      }
      onProgress((index + 1) / verses.length);
    }
  }

  void dispose() => _client.close();
}

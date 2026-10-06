import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/nurani_quran_document.dart';
import '../../domain/entities/quran/nurani_quran_state.dart';
import '../../domain/repositories/nurani_quran_repository.dart';

class NuraniQuranRepositoryImpl implements NuraniQuranRepository {
  NuraniQuranRepositoryImpl(this._client);

  final http.Client _client;
  Completer<void>? _abort;
  static const _timeout = Duration(seconds: 45);

  Future<File> _documentFile() async {
    final root = await getApplicationSupportDirectory();
    final directory = Directory(path.join(root.path, 'nurani_quran'));
    await directory.create(recursive: true);
    return File(path.join(directory.path, NuraniQuranDocument.fileName));
  }

  @override
  Future<NuraniQuranLibrary> loadLibrary() async {
    final preferences = await SharedPreferences.getInstance();
    var reading = NuraniQuranReadingState();
    final raw = preferences.getString(NuraniQuranDocument.preferencesKey);
    if (raw != null) {
      try {
        reading = NuraniQuranReadingState.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      } on FormatException {
        // A damaged preference must not prevent downloading or reading the PDF.
      } on TypeError {
        // Preserve the offline file even if reading metadata cannot be decoded.
      }
    }
    final file = await _documentFile();
    final available = await file.exists() && await _isPdf(file);
    return NuraniQuranLibrary(
      reading: reading,
      filePath: available ? file.path : null,
    );
  }

  @override
  Future<String> download({
    required void Function(int bytes, int? total) onProgress,
  }) async {
    if (_abort != null) throw StateError('A PDF download is already running');
    final abort = Completer<void>();
    _abort = abort;
    File? partial;
    RandomAccessFile? writer;
    try {
      final destination = await _documentFile();
      partial = File('${destination.path}.part');
      final response = await _client
          .send(
            http.AbortableRequest(
              'GET',
              NuraniQuranDocument.downloadUri,
              abortTrigger: abort.future,
            ),
          )
          .timeout(_timeout);
      if (response.statusCode != 200) {
        throw const NuraniQuranException(NuraniQuranIssue.network);
      }
      final contentType = response.headers['content-type']?.toLowerCase() ?? '';
      final total = response.contentLength;
      if (contentType.contains('text/html') ||
          (total != null && total > NuraniQuranDocument.maximumBytes)) {
        throw const NuraniQuranException(NuraniQuranIssue.invalidPdf);
      }
      writer = await partial.open(mode: FileMode.write);
      var received = 0;
      await for (final chunk in response.stream.timeout(_timeout)) {
        if (abort.isCompleted) {
          throw const NuraniQuranException(NuraniQuranIssue.cancelled);
        }
        received += chunk.length;
        if (received > NuraniQuranDocument.maximumBytes) {
          throw const NuraniQuranException(NuraniQuranIssue.invalidPdf);
        }
        await writer.writeFrom(chunk);
        onProgress(received, total);
      }
      await writer.flush();
      await writer.close();
      writer = null;
      if (abort.isCompleted) {
        throw const NuraniQuranException(NuraniQuranIssue.cancelled);
      }
      if ((total != null && received != total) || !await _isPdf(partial)) {
        throw const NuraniQuranException(NuraniQuranIssue.invalidPdf);
      }
      // Only promote a complete PDF; interrupted downloads never appear ready.
      await partial.rename(destination.path);
      return destination.path;
    } on http.RequestAbortedException {
      throw const NuraniQuranException(NuraniQuranIssue.cancelled);
    } on NuraniQuranException {
      rethrow;
    } on FileSystemException {
      throw const NuraniQuranException(NuraniQuranIssue.storage);
    } catch (_) {
      throw const NuraniQuranException(NuraniQuranIssue.network);
    } finally {
      if (!abort.isCompleted) abort.complete();
      try {
        await writer?.close();
        if (partial != null && await partial.exists()) await partial.delete();
      } on FileSystemException {
        // The next attempt truncates its own partial file before writing.
      }
      _abort = null;
    }
  }

  Future<bool> _isPdf(File file) async {
    final length = await file.length();
    if (length < 16 || length > NuraniQuranDocument.maximumBytes) return false;
    final reader = await file.open();
    try {
      final header = ascii.decode(await reader.read(5), allowInvalid: true);
      await reader.setPosition(length > 1024 ? length - 1024 : 0);
      final tail = latin1.decode(await reader.read(1024));
      return header == '%PDF-' && tail.contains('%%EOF');
    } finally {
      await reader.close();
    }
  }

  @override
  void cancelDownload() {
    final abort = _abort;
    if (abort != null && !abort.isCompleted) abort.complete();
  }

  @override
  Future<void> saveReading(NuraniQuranReadingState reading) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      NuraniQuranDocument.preferencesKey,
      jsonEncode(reading.toJson()),
    );
    if (!saved) throw const NuraniQuranException(NuraniQuranIssue.storage);
  }

  @override
  Future<void> removeDownload() async {
    final file = await _documentFile();
    if (await file.exists()) await file.delete();
    // Bookmarks and the last page belong to the document, not its offline copy.
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/science_in_quran_document.dart';
import '../../domain/entities/science_in_quran_state.dart';
import '../../domain/repositories/science_in_quran_repository.dart';

class ScienceInQuranRepositoryImpl implements ScienceInQuranRepository {
  ScienceInQuranRepositoryImpl(this._client);

  final http.Client _client;
  Completer<void>? _abort;
  ScienceInQuranDocument? _document;
  static const _timeout = Duration(seconds: 45);

  Future<File> _documentFile([ScienceInQuranDocument? document]) async {
    final root = await getApplicationSupportDirectory();
    final directory = Directory(path.join(root.path, 'science_in_quran'));
    await directory.create(recursive: true);
    return File(
      path.join(directory.path, document?.fileName ?? 'science_in_quran.pdf'),
    );
  }

  @override
  Future<ScienceInQuranLibrary> loadLibrary() async {
    final preferences = await SharedPreferences.getInstance();
    final document = ScienceInQuranDocument.fromLanguageName(
      preferences.getString(ScienceInQuranDocument.selectedLanguageKey),
    );
    final file = await _documentFile(document);
    final available =
        document != null &&
        await file.exists() &&
        await _isPdf(file, maximumBytes: document.maximumBytes);
    _document = document;
    return ScienceInQuranLibrary(
      reading: _readReading(preferences, document),
      filePath: available ? file.path : null,
      document: document,
    );
  }

  @override
  Future<ScienceInQuranLibrary> download({
    required ScienceInQuranDocument document,
    required void Function(int bytes, int? total) onProgress,
  }) async {
    if (_abort != null) throw StateError('A PDF download is already running');
    final abort = Completer<void>();
    _abort = abort;
    File? partial;
    RandomAccessFile? writer;
    try {
      final destination = await _documentFile(document);
      partial = File('${destination.path}.part');
      final response = await _client
          .send(
            http.AbortableRequest(
              'GET',
              document.downloadUri,
              abortTrigger: abort.future,
            ),
          )
          .timeout(_timeout);
      final contentType = response.headers['content-type']?.toLowerCase() ?? '';
      final total = response.contentLength;
      if (response.statusCode != 200 ||
          contentType.contains('text/html') ||
          (total != null && total > document.maximumBytes)) {
        throw const ScienceInQuranException(ScienceInQuranIssue.invalidPdf);
      }
      writer = await partial.open(mode: FileMode.write);
      var received = 0;
      await for (final chunk in response.stream.timeout(_timeout)) {
        if (abort.isCompleted) {
          throw const ScienceInQuranException(ScienceInQuranIssue.cancelled);
        }
        received += chunk.length;
        if (received > document.maximumBytes) {
          throw const ScienceInQuranException(ScienceInQuranIssue.invalidPdf);
        }
        await writer.writeFrom(chunk);
        onProgress(received, total);
      }
      await writer.flush();
      await writer.close();
      writer = null;
      if ((total != null && total != received) ||
          !await _isPdf(partial, maximumBytes: document.maximumBytes)) {
        throw const ScienceInQuranException(ScienceInQuranIssue.invalidPdf);
      }
      if (abort.isCompleted) {
        throw const ScienceInQuranException(ScienceInQuranIssue.cancelled);
      }
      await partial.rename(destination.path);
      final reading = await _selectDocument(document);
      _document = document;
      await _removeOtherCopies(document, destination.parent);
      return ScienceInQuranLibrary(
        reading: reading,
        filePath: destination.path,
        document: document,
      );
    } on http.RequestAbortedException {
      throw const ScienceInQuranException(ScienceInQuranIssue.cancelled);
    } on ScienceInQuranException {
      rethrow;
    } on FileSystemException {
      throw const ScienceInQuranException(ScienceInQuranIssue.storage);
    } catch (_) {
      throw const ScienceInQuranException(ScienceInQuranIssue.network);
    } finally {
      if (!abort.isCompleted) abort.complete();
      try {
        await writer?.close();
        if (partial != null && await partial.exists()) await partial.delete();
      } on FileSystemException {
        // A later attempt truncates its own partial file.
      }
      _abort = null;
    }
  }

  ScienceInQuranReadingState _readReading(
    SharedPreferences preferences,
    ScienceInQuranDocument? document,
  ) {
    if (document == null) return ScienceInQuranReadingState();
    try {
      final raw = preferences.getString(document.preferencesKey);
      if (raw != null) {
        return ScienceInQuranReadingState.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      }
    } on FormatException {
      // Damaged reading metadata should not hide a valid downloaded PDF.
    } on TypeError {
      // Start from page one if metadata has an unexpected shape.
    }
    return ScienceInQuranReadingState();
  }

  Future<ScienceInQuranReadingState> _selectDocument(
    ScienceInQuranDocument document,
  ) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final reading = _readReading(preferences, document);
      if (!await preferences.setString(
        ScienceInQuranDocument.selectedLanguageKey,
        document.language.name,
      )) {
        throw StateError('Could not save selected language');
      }
      return reading;
    } catch (_) {
      throw const ScienceInQuranException(ScienceInQuranIssue.storage);
    }
  }

  Future<void> _removeOtherCopies(
    ScienceInQuranDocument selected,
    Directory directory,
  ) async {
    for (final document in ScienceInQuranDocument.documents) {
      if (document == selected) continue;
      try {
        final file = File(path.join(directory.path, document.fileName));
        if (await file.exists()) await file.delete();
      } on FileSystemException {
        // Cleanup should not fail a completed download.
      }
    }
  }

  Future<bool> _isPdf(File file, {required int maximumBytes}) async {
    final length = await file.length();
    if (length < 16 || length > maximumBytes) return false;
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
    if (_abort case final abort?) {
      if (!abort.isCompleted) abort.complete();
    }
  }

  @override
  Future<void> saveReading(ScienceInQuranReadingState reading) async {
    final document = _document;
    if (document == null) return;
    final preferences = await SharedPreferences.getInstance();
    if (!await preferences.setString(
      document.preferencesKey,
      jsonEncode(reading.toJson()),
    )) {
      throw const ScienceInQuranException(ScienceInQuranIssue.storage);
    }
  }

  @override
  Future<void> removeDownload() async {
    for (final document in ScienceInQuranDocument.documents) {
      final file = await _documentFile(document);
      if (await file.exists()) await file.delete();
    }
  }
}

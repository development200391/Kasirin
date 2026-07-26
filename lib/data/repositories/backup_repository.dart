import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../db/database_helper.dart';
import '../models/backup_entry.dart';

class InvalidBackupFileException implements Exception {}

class BackupRepository {
  Future<Directory> _backupDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/backups');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<File> _historyFile() async {
    final dir = await _backupDir();
    return File('${dir.path}/history.json');
  }

  Future<String> backupFilePath(BackupEntry entry) async {
    final dir = await _backupDir();
    return '${dir.path}/${entry.fileName}';
  }

  Future<List<BackupEntry>> getHistory() async {
    final file = await _historyFile();
    if (!await file.exists()) return [];

    final raw = await file.readAsString();
    if (raw.trim().isEmpty) return [];

    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    final entries = list.map(BackupEntry.fromJson).toList();
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  Future<void> _saveHistory(List<BackupEntry> entries) async {
    final file = await _historyFile();
    await file.writeAsString(jsonEncode(entries.map((e) => e.toJson()).toList()));
  }

  Future<bool> _looksLikeSqlite(File file) async {
    final raf = await file.open();
    try {
      final header = await raf.read(16);
      return utf8.decode(header, allowMalformed: true).startsWith('SQLite format 3');
    } finally {
      await raf.close();
    }
  }

  Future<BackupEntry> createManualBackup() async {
    final dbPath = await DatabaseHelper.instance.databasePath;
    final sourceFile = File(dbPath);

    final fileName = 'kasirin_backup_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.db';
    final dir = await _backupDir();
    final backupFile = await sourceFile.copy('${dir.path}/$fileName');

    final entry = BackupEntry(
      fileName: fileName,
      createdAt: DateTime.now(),
      sizeBytes: await backupFile.length(),
      source: BackupSource.manual,
    );

    final history = await getHistory();
    history.add(entry);
    await _saveHistory(history);

    return entry;
  }

  Future<BackupEntry> importBackupFile(String sourcePath) async {
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists() || !await _looksLikeSqlite(sourceFile)) {
      throw InvalidBackupFileException();
    }

    final fileName = 'kasirin_import_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.db';
    final dir = await _backupDir();
    final backupFile = await sourceFile.copy('${dir.path}/$fileName');

    final entry = BackupEntry(
      fileName: fileName,
      createdAt: DateTime.now(),
      sizeBytes: await backupFile.length(),
      source: BackupSource.imported,
    );

    final history = await getHistory();
    history.add(entry);
    await _saveHistory(history);

    return entry;
  }

  Future<void> restoreBackup(BackupEntry entry) async {
    final dir = await _backupDir();
    final backupFile = File('${dir.path}/${entry.fileName}');
    if (!await backupFile.exists()) {
      throw InvalidBackupFileException();
    }

    final dbPath = await DatabaseHelper.instance.databasePath;
    await DatabaseHelper.instance.close();
    await backupFile.copy(dbPath);
  }
}

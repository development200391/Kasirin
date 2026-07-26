import 'package:flutter/foundation.dart';

import '../../data/models/backup_entry.dart';
import '../../data/repositories/backup_repository.dart';

class BackupProvider extends ChangeNotifier {
  BackupProvider({BackupRepository? repository}) : _repository = repository ?? BackupRepository() {
    load();
  }

  final BackupRepository _repository;

  List<BackupEntry> _history = [];
  List<BackupEntry> get history => _history;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isWorking = false;
  bool get isWorking => _isWorking;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _history = await _repository.getHistory();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createBackup() async {
    _isWorking = true;
    notifyListeners();

    var success = true;
    try {
      await _repository.createManualBackup();
    } catch (_) {
      success = false;
    }

    await load();
    _isWorking = false;
    notifyListeners();
    return success;
  }

  Future<bool> importFile(String sourcePath) async {
    _isWorking = true;
    notifyListeners();

    var success = true;
    try {
      await _repository.importBackupFile(sourcePath);
    } catch (_) {
      success = false;
    }

    await load();
    _isWorking = false;
    notifyListeners();
    return success;
  }

  Future<bool> restore(BackupEntry entry) async {
    _isWorking = true;
    notifyListeners();

    var success = true;
    try {
      await _repository.restoreBackup(entry);
    } catch (_) {
      success = false;
    }

    _isWorking = false;
    notifyListeners();
    return success;
  }
}

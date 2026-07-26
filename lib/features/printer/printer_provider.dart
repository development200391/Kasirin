import 'package:flutter/foundation.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../core/utils/receipt_formatter.dart';
import '../../data/models/transaction_result.dart';
import '../../data/repositories/printer_repository.dart';
import '../../data/repositories/printer_settings_repository.dart';

class PrinterProvider extends ChangeNotifier {
  PrinterProvider({
    PrinterRepository? repository,
    PrinterSettingsRepository? settingsRepository,
  })  : _repository = repository ?? PrinterRepository(),
        _settingsRepository = settingsRepository ?? PrinterSettingsRepository();

  final PrinterRepository _repository;
  final PrinterSettingsRepository _settingsRepository;

  List<BluetoothInfo> _devices = [];
  List<BluetoothInfo> get devices => _devices;

  bool _isLoadingDevices = false;
  bool get isLoadingDevices => _isLoadingDevices;

  String? _connectingAddress;
  String? get connectingAddress => _connectingAddress;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  String? _connectedAddress;
  String? get connectedAddress => _connectedAddress;

  String? _connectedName;
  String? get connectedName => _connectedName;

  int _paperWidthMm = 58;
  int get paperWidthMm => _paperWidthMm;

  bool _autoPrint = false;
  bool get autoPrint => _autoPrint;

  Future<void> init() async {
    _paperWidthMm = await _settingsRepository.getPaperWidthMm();
    _autoPrint = await _settingsRepository.getAutoPrint();
    _connectedAddress = await _settingsRepository.getSavedAddress();
    _connectedName = await _settingsRepository.getSavedName();
    notifyListeners();

    await refreshStatus();
    if (!_isConnected && _connectedAddress != null) {
      // Best-effort silent reconnect to the last used printer.
      await connect(BluetoothInfo(name: _connectedName ?? '', macAdress: _connectedAddress!));
    }
    await loadDevices();
  }

  Future<void> refreshStatus() async {
    _isConnected = await _repository.isConnected;
    notifyListeners();
  }

  Future<void> loadDevices() async {
    _isLoadingDevices = true;
    notifyListeners();

    await _repository.ensurePermissions();
    _devices = await _repository.pairedDevices();

    _isLoadingDevices = false;
    notifyListeners();
  }

  Future<bool> connect(BluetoothInfo device) async {
    _connectingAddress = device.macAdress;
    notifyListeners();

    await _repository.ensurePermissions();
    final success = await _repository.connect(device.macAdress);

    if (success) {
      _isConnected = true;
      _connectedAddress = device.macAdress;
      _connectedName = device.name;
      await _settingsRepository.saveDevice(device.macAdress, device.name);
    }

    _connectingAddress = null;
    notifyListeners();
    return success;
  }

  Future<void> disconnectPrinter() async {
    await _repository.disconnect();
    _isConnected = false;
    notifyListeners();
  }

  Future<void> setPaperWidthMm(int mm) async {
    _paperWidthMm = mm;
    notifyListeners();
    await _settingsRepository.setPaperWidthMm(mm);
  }

  Future<void> setAutoPrint(bool value) async {
    _autoPrint = value;
    notifyListeners();
    await _settingsRepository.setAutoPrint(value);
  }

  Future<bool> printReceipt(TransactionResult result) async {
    await refreshStatus();
    if (!_isConnected) return false;
    return _repository.printBytes(buildReceiptBytes(result, paperWidthMm: _paperWidthMm));
  }

  Future<bool> testPrint() async {
    await refreshStatus();
    if (!_isConnected) return false;
    return _repository.printBytes(
      buildTestPrintBytes(paperWidthMm: _paperWidthMm, printerName: _connectedName ?? 'Printer'),
    );
  }
}

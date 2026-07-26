import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrinterRepository {
  Future<bool> ensurePermissions() async {
    final statuses = await [Permission.bluetoothConnect, Permission.bluetoothScan].request();
    return statuses.values.every((status) => status.isGranted || status.isLimited);
  }

  Future<bool> isBluetoothEnabled() => PrintBluetoothThermal.bluetoothEnabled;

  Future<List<BluetoothInfo>> pairedDevices() => PrintBluetoothThermal.pairedBluetooths;

  Future<bool> connect(String macAddress) => PrintBluetoothThermal.connect(macPrinterAddress: macAddress);

  Future<bool> get isConnected => PrintBluetoothThermal.connectionStatus;

  Future<bool> disconnect() => PrintBluetoothThermal.disconnect;

  Future<bool> printBytes(List<int> bytes) => PrintBluetoothThermal.writeBytes(bytes);
}

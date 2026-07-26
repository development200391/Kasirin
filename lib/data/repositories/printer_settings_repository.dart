import 'package:shared_preferences/shared_preferences.dart';

class PrinterSettingsRepository {
  static const _keyAddress = 'printer_address';
  static const _keyName = 'printer_name';
  static const _keyPaperWidth = 'printer_paper_width_mm';
  static const _keyAutoPrint = 'printer_auto_print';

  Future<String?> getSavedAddress() async => (await SharedPreferences.getInstance()).getString(_keyAddress);

  Future<String?> getSavedName() async => (await SharedPreferences.getInstance()).getString(_keyName);

  Future<int> getPaperWidthMm() async => (await SharedPreferences.getInstance()).getInt(_keyPaperWidth) ?? 58;

  Future<bool> getAutoPrint() async => (await SharedPreferences.getInstance()).getBool(_keyAutoPrint) ?? false;

  Future<void> saveDevice(String address, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAddress, address);
    await prefs.setString(_keyName, name);
  }

  Future<void> setPaperWidthMm(int mm) async => (await SharedPreferences.getInstance()).setInt(_keyPaperWidth, mm);

  Future<void> setAutoPrint(bool value) async => (await SharedPreferences.getInstance()).setBool(_keyAutoPrint, value);
}

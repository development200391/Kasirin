import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const _prefsKey = 'app_locale';
  static const supportedLocales = [Locale('id'), Locale('en'), Locale('ja')];

  static const _intlTags = {'id': 'id_ID', 'en': 'en_US', 'ja': 'ja_JP'};

  Locale _locale = const Locale('id');
  Locale get locale => _locale;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null && supportedLocales.any((l) => l.languageCode == saved)) {
      _locale = Locale(saved);
    }
    await _applyIntlLocale(_locale);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (locale == _locale) return;
    _locale = locale;
    await _applyIntlLocale(locale);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
  }

  Future<void> _applyIntlLocale(Locale locale) async {
    final tag = _intlTags[locale.languageCode] ?? 'id_ID';
    await initializeDateFormatting(tag);
    Intl.defaultLocale = tag;
  }
}

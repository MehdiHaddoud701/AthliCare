// Create a new file: lib/services/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:athlicare/services/locale_service.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final savedLocaleCode = await LocaleService.getLocale();
    _locale = LocaleService.stringToLocale(savedLocaleCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    await LocaleService.saveLocale(locale.languageCode);
    notifyListeners();
  }
}

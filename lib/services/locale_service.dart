// File: lib/services/locale_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LocaleService {
  static const String _localeKey = 'app_locale';
  static const String _defaultLocale = 'en';

  /// Save locale preference to SharedPreferences
  static Future<void> saveLocale(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, languageCode);
      print('✓ Saved locale: $languageCode');
    } catch (e) {
      print('✗ Error saving locale: $e');
    }
  }

  /// Retrieve saved locale from SharedPreferences
  static Future<String> getLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locale = prefs.getString(_localeKey) ?? _defaultLocale;
      print('✓ Retrieved locale: $locale');
      return locale;
    } catch (e) {
      print('✗ Error retrieving locale: $e');
      return _defaultLocale;
    }
  }

  /// Convert language code string to Locale object
  static Locale stringToLocale(String languageCode) {
    return Locale(languageCode);
  }

  /// Clear saved locale (reset to default)
  static Future<void> clearLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_localeKey);
      print('✓ Cleared locale preference');
    } catch (e) {
      print('✗ Error clearing locale: $e');
    }
  }
}

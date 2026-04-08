// Create file: lib/logic/locale_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:athlicare/services/locale_service.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en')) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final savedLocaleCode = await LocaleService.getLocale();
    emit(LocaleService.stringToLocale(savedLocaleCode));
  }

  Future<void> changeLocale(Locale locale) async {
    await LocaleService.saveLocale(locale.languageCode);
    emit(locale);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationCubit extends Cubit<Locale> {
  static const String _key = 'app_locale';

  final SharedPreferences preferences;

  LocalizationCubit({
    required this.preferences,
  }) : super(
          Locale(
            preferences.getString(_key) == 'ar' ? 'ar' : 'en',
          ),
        );

  Future<void> changeLanguage(Locale locale) async {
    if (locale.languageCode != 'en' &&
        locale.languageCode != 'ar') {
      return;
    }

    if (state.languageCode == locale.languageCode) {
      return;
    }

    emit(locale);

    await preferences.setString(
      _key,
      locale.languageCode,
    );
  }

  bool get isArabic => state.languageCode == 'ar';

  bool get isEnglish => state.languageCode == 'en';
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/helpers/SharedPreference/pereferences.dart';
import '../core/langCode.dart';
import '../core/preferences_constants.dart';


class LanguageCubit extends Cubit<Locale> {
  final SharedPreferencesHelper sharedPreferencesHelper;
  LanguageCubit(this.sharedPreferencesHelper) : super(Locale('ar')) {
    emitLocale();
  }

  emitLocale() async {
    langCode = await sharedPreferencesHelper.get(PreferencesConstants.lang) ?? "ar";
    emit(Locale(await sharedPreferencesHelper.get(PreferencesConstants.lang) ?? "ar"));
  }

  void selectEngLanguage() async {
    await sharedPreferencesHelper.set(PreferencesConstants.lang, "en");
    langCode = 'en';
    emit(Locale('en'));
  }

  void selectArabicLanguage() async {
    await sharedPreferencesHelper.set(PreferencesConstants.lang, "ar");
    langCode = 'ar';
    emit(Locale('ar'));
  }

}

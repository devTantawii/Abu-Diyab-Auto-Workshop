import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('ar')); // اللغة الافتراضية عربية

  void switchToArabic() => emit(const Locale('ar'));
  void switchToEnglish() => emit(const Locale('en'));

  void toggleLanguage() {
    if (state.languageCode == 'ar') {
      emit(const Locale('en'));
    } else {
      emit(const Locale('ar'));
    }
  }
}

import 'package:flutter/cupertino.dart';

import '../../../language/locale.dart';

class Validate {
  static String? validateName(BuildContext context , String? value) {
    final locale = AppLocalizations.of(context);

    if (value == null) {
      return null;
    }
    if (value.isEmpty) {
      return locale!.pleaseEnterName;
    }

    if (value.length < 4) {
      return locale!.enterNameMiniChars;
    }
    return null;
  }

  static String? validateEmail(BuildContext context , String? value, {String? error}) {
    final locale = AppLocalizations.of(context);

    if (value == null) return null;
    if (value.isEmpty) {
      return locale!.pleaseEnterEmail;
    }
    const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final RegExp regex = RegExp(emailPattern);
    if (!regex.hasMatch(value)) return locale!.enterValidEmail;

    if (error != null) return error;

    return null;
  }

  static String? validateSelectCountry(String? value) {
    // final locale = AppLocalizations.of(context);

    if (value == null) {
      return null;
    }
    if (value.isEmpty) {
      return 'Please select country';
    }
    return null;
  }

  static String? validateUserId(BuildContext context, String? value) {
    final locale = AppLocalizations.of(context);

    if (value == null) {
      return null;
    }

    if (value.isEmpty) {
      return locale!.isDirectionRTL(context) ? "الرجاء إدخال رقم الهويه" : "Please enter your ID number.";
    }

    if (value.length != 10) {
      return locale!.isDirectionRTL(context) ? "الرجاء رقم الهويه يساوى 10 ارقام" : "Please, the ID number must be  10 number.";
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return locale!.isDirectionRTL(context)
          ? 'الرجاء إدخال أرقام فقط'
          : 'Please enter numbers only';
    }

    // Check if the ID starts with '1'
    if (!value.startsWith('1')) {
      return locale!.isDirectionRTL(context)
          ? 'الرجاء أن يبدأ رقم الهوية بالرقم 1'
          : 'Please ensure the ID number starts with 1.';
    }

    return null;
  }

  static String? validateUserIdVisit(BuildContext context, String? value) {
    final locale = AppLocalizations.of(context);

    if (value == null) {
      return null;
    }

    if (value.isEmpty) {
      return locale!.isDirectionRTL(context) ? "الرجاء إدخال رقم الهويه" : "Please enter your ID number.";
    }

    if (value.length != 10) {
      return locale!.isDirectionRTL(context) ? "الرجاء رقم الهويه يساوى 10 ارقام" : "Please, the ID number must be  10 number.";
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return locale!.isDirectionRTL(context)
          ? 'الرجاء إدخال أرقام فقط'
          : 'Please enter numbers only';
    }

    // Check if the ID starts with '1'
    if (!value.startsWith('2')) {
      return locale!.isDirectionRTL(context)
          ? 'الرجاء أن يبدأ رقم الاقامه بالرقم 2'
          : 'Please ensure the ID number starts with 2.';
    }

    return null;
  }


  static String? validatePhoneNumber(BuildContext context, String? value) {
    final locale = AppLocalizations.of(context);

    if (value == null) {
      return null;
    }

    if (value.isEmpty) {
      return locale!.pleaseEnterPhoneNumber;
    }

    // The regex pattern for Saudi phone number
    final regex = RegExp(r'^(009665|9665|\+9665|5)(5|3|6|4|9|1|8|7|0)([0-9]{7})$');

    if (!regex.hasMatch(value)) {
      return locale!.isDirectionRTL(context) ? "الرجاء إدخال رقم جوال صالح" : "Please Enter a valid phone number.";
    }

    return null;
  }


  static String? validatePassword(BuildContext context , String? value, {String? confirmPassword}) {
    final locale = AppLocalizations.of(context);
    if (value == null) {
      return null;
    }
    if (confirmPassword != null && value != confirmPassword) {
      return locale!.passwordNotMatching;
    }
    if (value.isEmpty) {
      return locale!.pleaseEnterPassword;
    }
    return null;
  }


  static String? validateCreditCardNumber(BuildContext context, String? value) {
    final locale = AppLocalizations.of(context);
    if (value == null) return null;
    if (value.isEmpty) return locale!.pleaseEnterValidCredit;

    // validating common credit card types
    String pattern = r'^(?:4[0-9]{3}[- ]?[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4}' // Visa
        r'|5[1-5][0-9]{2}[- ]?[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4}'           // MasterCard
        r'|3[47][0-9]{2}[- ]?[0-9]{6}[- ]?[0-9]{5}'            // American Express
        r'|3(?:0[0-5]|[68][0-9])[- ]?[0-9]{4}[- ]?[0-9]{6}[- ]?[0-9]{4}' // Diners Club
        r'|6(?:011|5[0-9]{2})[- ]?[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4}'   // Discover
        r'|(?:2131|1800|35[0-9]{2})[- ]?[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4})$'; // JCB


    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return locale!.pleaseEnterValidCredit;
    }

    return null;
  }

  static String? validateCVV(BuildContext context, String? value) {
    final locale = AppLocalizations.of(context);

    if (value == null) return null;
    if (value.isEmpty) return locale!.enterValidCVV;


    String pattern = r'^[0-9]\d{2,3}$';


    RegExp regExp = RegExp(pattern);


    if (!regExp.hasMatch(value)) {
      return locale!.enterValidCVV;
    }

    return null;
  }


  static String? validateDate(String? value) {
    if (value == null) return null;
    if (value.isEmpty) return " ";
    if (value.length < 2) return " ";
    return null;
  }

  static String? validateMonth(BuildContext context, String? monthValue) {
    final locale = AppLocalizations.of(context);

    if (monthValue == null || monthValue.isEmpty) {
      return locale!.isDirectionRTL(context) ? "الرجاء إدخال شهر انتهاء." : "Please enter Expire month.";
    }

    final int? month = int.tryParse(monthValue);

    if (month == null || month < 1 || month > 12) {
      return locale!.isDirectionRTL(context) ?"الرجاء إدخال الشهر من 1 : 12 صالحًا" : "Please enter valid Month 1 : 12.";
    }

    return null;
  }

  static String? validateYear(BuildContext context, String? yearValue, String? monthValue) {
    final locale = AppLocalizations.of(context);

    if (yearValue == null || yearValue.isEmpty) {
      return locale!.isDirectionRTL(context) ? "الرجاء إدخال سنه انتهاء." : "Please enter Expire year.";
    }

    final int? year = int.tryParse(yearValue);
    if (year == null || year < 0) {
      return locale!.isDirectionRTL(context) ? "الرجاء إدخال سنة صالحة." : "Please enter valid year.";
    }

    // Get the current year and month
    final DateTime now = DateTime.now();
    final int currentYear = now.year;
    final int currentMonth = now.month;


    if (year + 2000 < currentYear) {
      return locale!.isDirectionRTL(context)? "بطاقتك منتهية الصلاحية." : "your card is expired. " ;
    }

    if (year + 2000 == currentYear && monthValue != null && monthValue.isNotEmpty) {
      final int? month = int.tryParse(monthValue);
      if (month != null && month < currentMonth) {
        return locale!.isDirectionRTL(context)? "بطاقتك منتهية الصلاحية." : "your card is expired. " ;
      }
    }

    return null;
  }


}

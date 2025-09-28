import 'package:abu_diyab_workshop/core/helpers/validation/validation.dart';
import 'package:flutter/cupertino.dart';


class FormValidator {
  static String? passwordValidate(BuildContext context , String? value) {
    final passwordValidator = Validate.validatePassword(context , value);
    if (passwordValidator == null) {
      return null;
    } else {
      return passwordValidator;
    }
  }

  static String? passwordConfirmValidate(BuildContext context ,String? value, String? confirmValue) {
    final passwordValidator =
        Validate.validatePassword( context ,value, confirmPassword: confirmValue);
    if (passwordValidator == null) {
      return null;
    } else {
      return passwordValidator;
    }
  }

  static String? emailValidate(BuildContext context , String? value) {
    final emailValidator = Validate.validateEmail( context ,value);
    if (emailValidator == null) {
      return null;
    } else {
      return emailValidator;
    }
  }

  static String? phoneValidate(BuildContext context ,String? value) {
    final phoneValidator = Validate.validatePhoneNumber( context ,value);
    if (phoneValidator == null) {

      return null;
    } else {
      return phoneValidator;
    }
  }

  static String? nameValidate(BuildContext context ,String? value) {
    final nameValidator = Validate.validateName( context ,value);
    if (nameValidator == null) {
      return null;
    } else {
      return nameValidator;
    }
  }
  static String? numValidate(BuildContext context ,String? value) {
    final numberValidator = Validate.validateUserId( context ,value);
    if (numberValidator == null) {
      return null;
    } else {
      return numberValidator;
    }
  }
  static String? numVisitValidate(BuildContext context ,String? value) {
    final numberValidator = Validate.validateUserIdVisit( context ,value);
    if (numberValidator == null) {
      return null;
    } else {
      return numberValidator;
    }
  }

  static String? creditValidate(BuildContext context ,String? value) {
    final validator = Validate.validateCreditCardNumber( context ,value);
    if (validator == null) {
      return null;
    } else {
      return validator;
    }
  }

  static String? cvvValidate(BuildContext context ,String? value) {
    final validator = Validate.validateCVV( context ,value);
    if (validator == null) {
      return null;
    } else {
      return validator;
    }
  }

  static String? monthValidate(BuildContext context ,String? value) {
    final validator = Validate.validateMonth( context ,value);
    if (validator == null) {
      return null;
    } else {
      return validator;
    }
  }

  static String? yearValidate(BuildContext context, String? yearValue, String? monthValue) {
    final validator = Validate.validateYear(context, yearValue, monthValue);
    if (validator == null) {
      return null;
    } else {
      return validator;
    }
  }


  static String? dateValidate(String? value) {
    final validator = Validate.validateDate(value);
    if (validator == null) {
      return null;
    } else {
      return validator;
    }
  }
}

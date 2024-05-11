import 'package:email_validator/email_validator.dart';

class ValidationForm {
  static bool validateMobile(String value) {
    String pattern = r'^(?:7|0|(?:\+94))[0-9]{9}$';
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(value)) {
      return true;
    } else {}
    return false;
  }

  static bool emailValidation(String value) {
    if (value.isNotEmpty) {
      if (EmailValidator.validate(value)) {
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  static bool addressFieldValidation(String value, String text) {
    if (value.isNotEmpty && value.length > 4) {
      return true;
    } else {}
    return false;
  }

  static bool userNameValidation(String value, String text) {
    if (value.isEmpty || value.length < 6) {
      return false;
    }
    return true;
  }

  static bool passwordValidation(String value, String text) {
    String pattern =
        r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$";
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(value)) {
      return true;
    } else {}
    return false;
  }

  static bool birthDay(String value, String text) {
    if (value.isNotEmpty) {
      return true;
    } else {}
    return false;
  }
}

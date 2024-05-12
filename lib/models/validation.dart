import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ValidationForm {
  static bool validateMobile(String value) {
    String pattern = r'^(?:7|0|(?:\+94))[0-9]{9}$';
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(value)) {
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Mobile Number is Wrong", toastLength: Toast.LENGTH_LONG);
    }
    return false;
  }

  static bool emailValidation(String value) {
    if (value.isNotEmpty) {
      if (EmailValidator.validate(value)) {
        return true;
      }
      Fluttertoast.showToast(
          msg: "Email Address is Wrong", toastLength: Toast.LENGTH_LONG);
      return false;
    } else {
      return false;
    }
  }

  static bool addressFieldValidation(String value, String text) {
    if (value.isNotEmpty && value.length > 4) {
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Home Address is Wrong", toastLength: Toast.LENGTH_LONG);
    }
    return false;
  }

  static bool userNameValidation(String value, String text) {
    if (value.isEmpty || value.length < 6) {
      Fluttertoast.showToast(
          msg: "user Name is Wrong", toastLength: Toast.LENGTH_LONG);
      return false;
    }
    return true;
  }

  static bool passwordValidation(String value, String text) {
    String pattern = r"^[A-Za-z0-9]{5,}$";
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(value)) {
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Password is Wrong", toastLength: Toast.LENGTH_LONG);
    }
    return false;
  }

  static bool birthDay(String value, String text) {
    if (value.isNotEmpty) {
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Birth Day is Wrong", toastLength: Toast.LENGTH_LONG);
    }
    return false;
  }
}

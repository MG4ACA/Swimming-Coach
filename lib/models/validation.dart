import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ValidationForm {
  static FirebaseFirestore? db;

  static bool validateMobile(String value) {
    String pattern = r'^(?:7|0|(?:\+94))[0-9]{9}$';
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(value)) {
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Enter valid mobile number.", toastLength: Toast.LENGTH_LONG);
    }
    return false;
  }

  static Future<bool> emailValidation(String value) async {
    var duplicateEmail = false;
    
    if (value.isNotEmpty) {
      if (EmailValidator.validate(value)) {
        db = FirebaseFirestore.instance;
        await db!.collection("users").get().then((event) {
          for (var doc in event.docs) {
            if (doc.data()["email"] == value) {
              duplicateEmail = true;
              Fluttertoast.showToast(
                  msg: "Duplicate email address.",
                  toastLength: Toast.LENGTH_LONG);
              return false;
            }
          }
        }).onError((error, stackTrace) {
          print(error);
          return false;
        });
        return duplicateEmail ? false : true;
      } else {
        Fluttertoast.showToast(
            msg: "Enter valid email address.", toastLength: Toast.LENGTH_LONG);
        return false;
      }
    } else {
      return false;
    }
  }

  static bool addressFieldValidation(String value, String text) {
    if (value.isNotEmpty && value.length > 4) {
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Enter valid address.", toastLength: Toast.LENGTH_LONG);
    }
    return false;
  }

  static bool userNameValidation(String value, String text) {
    if (value.isEmpty || value.length < 6) {
      Fluttertoast.showToast(
          msg: "Full name must be more than 10 characters.",
          toastLength: Toast.LENGTH_LONG);
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
          msg: "Enter valid password.", toastLength: Toast.LENGTH_LONG);
    }
    return false;
  }

  static bool birthDay(String value, String text) {
    if (value.isNotEmpty) {
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Enter valid birthday.", toastLength: Toast.LENGTH_LONG);
    }
    return false;
  }

  static bool confirmationPasswordValidation(String trim, String s) {
    if (trim == s) {
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Password does not match.", toastLength: Toast.LENGTH_LONG);
      return false;
    }
  }
}

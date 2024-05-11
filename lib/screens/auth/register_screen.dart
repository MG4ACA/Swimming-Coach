import 'package:flutter/material.dart';
import 'package:mituranga_project/models/validation.dart';
import 'package:mituranga_project/screens/auth/login_screen.dart';
import 'package:mituranga_project/screens/auth/secondary_page.dart';

import '../../components/button_component.dart';
import '../../components/text_component.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController contactNo = TextEditingController();
  TextEditingController birthDay = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController rePassword = TextEditingController();
  bool visibility = false;

  //Date Picker
  DateTime _dateTime = DateTime.now();
  // late Timer _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    fullName.clear();
    email.clear();
    address.clear();
    contactNo.clear();
    birthDay.clear();
    password.clear();
    rePassword.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue.shade600,
                Colors.red.shade700,
              ],
            ),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 60,
                ),
                const Icon(
                  Icons.lock_outline,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Wrap(
                  children: [
                    Text(
                      "Swimming Coach",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                TextComponent(
                  controller: fullName,
                  obscureText: false,
                  hintText: "Full Name",
                  keyboardType: TextInputType.text,
                ),
                TextComponent(
                  controller: email,
                  obscureText: false,
                  hintText: "email",
                  keyboardType: TextInputType.emailAddress,
                ),
                TextComponent(
                  controller: address,
                  obscureText: false,
                  hintText: "Address",
                  keyboardType: TextInputType.streetAddress,
                ),
                TextComponent(
                  controller: contactNo,
                  obscureText: false,
                  hintText: "Contact Number",
                  keyboardType: TextInputType.phone,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 280,
                          height: 55,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.white54),
                              borderRadius: BorderRadius.circular(5)),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextField(
                              controller: birthDay,
                              textAlign: TextAlign.start,
                              decoration:
                                  const InputDecoration(hintText: "BirthDay"),
                              enabled: false,
                            ),
                          ),
                        ),
                        Container(
                            child: IconButton(
                          icon: const Icon(Icons.date_range),
                          onPressed: () {
                            _showDatePicker();
                          },
                        )),
                      ]),
                ),
                TextComponent(
                  controller: password,
                  obscureText: visibility,
                  maxLines: 1,
                  hintText: "password",
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          if (visibility) {
                            visibility = false;
                          } else {
                            visibility = true;
                          }
                        });
                      },
                      icon: visibility
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility)),
                ),
                TextComponent(
                  controller: rePassword,
                  obscureText: visibility,
                  hintText: "Re enter Password",
                  maxLines: 1,
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          if (visibility) {
                            visibility = false;
                          } else {
                            visibility = true;
                          }
                        });
                      },
                      icon: visibility
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility)),
                ),
                const SizedBox(
                  height: 30,
                ),
                ButtonComponent(
                    onTap: () {
                      if (checkValidation() &&
                          password.text.trim() == rePassword.text.trim()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SecondaryScreen(
                                fullName: fullName.text,
                                email: email.text,
                                address: address.text,
                                contactNo: contactNo.text,
                                birthDay: birthDay.text,
                                password: password.text,
                              ),
                            ));
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Information"),
                              content: Text("Enter the correct data"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("ok"))
                              ],
                            );
                          },
                        );
                      }
                    },
                    buttonText: "Next"),
                TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Do you have a account ?",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ));
                            },
                            child: const Text("Login",
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 16)))
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDatePicker() async {
    await showDatePicker(
            locale: const Locale('en'),
            context: context,
            initialDate: DateTime(1990),
            firstDate: DateTime(1980),
            lastDate: DateTime.now())
        .then((datevalue) {
      setState(() {
        if (datevalue == null) {
          birthDay.text = '';
        } else {
          _dateTime = datevalue;
          String onlydate = DateFormat("yyyy-MM-dd").format(_dateTime);
          birthDay.text = onlydate;
        }
      });
      return null;
    });
  }

  bool checkValidation() {
    if (ValidationForm.userNameValidation(fullName.text.trim(), "full Name") &&
        ValidationForm.birthDay(birthDay.text.trim(), "Birth Day") &&
        ValidationForm.emailValidation(email.text.trim()) &&
        ValidationForm.validateMobile(contactNo.text.trim()) &&
        ValidationForm.addressFieldValidation(address.text.trim(), "Address") &&
        ValidationForm.passwordValidation(password.text.trim(), "Password")) {
      return true;
    } else {
      return false;
    }
  }
}

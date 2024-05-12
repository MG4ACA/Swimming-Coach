import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mituranga_project/components/button_component.dart';
import 'package:mituranga_project/components/text_component.dart';
import 'package:mituranga_project/screens/auth/register_screen.dart';
import 'package:mituranga_project/screens/main/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool visibility = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                HexColor('#2E3192'),
                HexColor('1BFFFF'),
              ],
            ),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
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
                  controller: email,
                  obscureText: false,
                  hintText: "email",
                  keyboardType: TextInputType.emailAddress,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "forgot password",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                ButtonComponent(
                    onTap: () {
                      loginMethod();
                    },
                    buttonText: "Login"),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No account yet ?",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ));
                          },
                          child: const Text("Register",
                              style: TextStyle(
                                  color: Colors.white54, fontSize: 16)))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginMethod() async {
    // Obtain shared preferences.
    final SharedPreferences prefS = await SharedPreferences.getInstance();
    if (email.text.trim().isNotEmpty && password.text.trim().isNotEmpty) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: email.text.trim(), password: password.text.trim())
            .then(
          (value) {
            prefS.setString("email", value.user!.email!);
            email.clear();
            password.clear();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ));
          },
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("User Not Found"),
                content: Text("No user found for that email."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Ok")),
                ],
              );
            },
          );
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Wrong Password"),
                content: Text("Wrong password provided for that user."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Ok")),
                ],
              );
            },
          );
          print('Wrong password provided for that user.');
        }
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Password Field"),
            content: Text("Password Field Empty"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok")),
            ],
          );
        },
      );
      print('Wrong password provided for that user.');
    }
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

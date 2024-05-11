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
                  height: 50,
                ),
                const Icon(
                  Icons.lock_open,
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
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ));
          },
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    } else {
      print('Wrong password provided for that user.');
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mituranga_project/components/button_component.dart';
import 'package:mituranga_project/components/text_component.dart';
import 'package:mituranga_project/models/user_model.dart';
import 'package:mituranga_project/screens/auth/login_screen.dart';

class SecondaryScreen extends StatefulWidget {
  final String fullName;
  final String email;
  final String address;
  final String contactNo;
  final String birthDay;
  final String password;

  const SecondaryScreen(
      {super.key,
      required this.fullName,
      required this.email,
      required this.address,
      required this.contactNo,
      required this.birthDay,
      required this.password});

  @override
  State<SecondaryScreen> createState() => _SecondaryScreenState();
}

class _SecondaryScreenState extends State<SecondaryScreen> {
  TextEditingController height = TextEditingController();
  TextEditingController weight = TextEditingController();
  final String hw = "KG";
  final item5 = ["Beginner Level", "Intermediate Level", "Advance Level"];
  String? selectLevel;
  FirebaseFirestore? db;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = FirebaseFirestore.instance;
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
                HexColor('#2E3192'),
                HexColor('1BFFFF'),
              ],
            ),
          ),
          child: Column(children: [
            const SizedBox(
              height: 100,
            ),
            const Icon(
              Icons.person,
              size: 140,
              color: Colors.white,
            ),
            const Text(
              "personal details",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 300,
                    child: TextComponent(
                        hintText: "Height",
                        obscureText: false,
                        controller: height,
                        keyboardType: TextInputType.number),
                  ),
                  Text("cm"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 300,
                    child: TextComponent(
                        hintText: "Weight",
                        obscureText: false,
                        controller: weight,
                        keyboardType: TextInputType.number),
                  ),
                  Text(hw),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonComponent(
              buttonText: "Save",
              onTap: () {
                if (weight.text.trim().isNotEmpty &&
                    height.text.trim().isNotEmpty) {
                  registerMethod();
                } else {
                  print("Data is Empty");
                }
              },
            ),
          ]),
        ),
      ),
    );
  }

  void registerMethod() async {
    UserModel userData = UserModel(
      fullName: widget.fullName,
      address: widget.address,
      contactNumber: widget.contactNo,
      email: widget.email,
      birthDay: widget.birthDay,
      weight: weight.text.trim(),
      height: height.text.trim(),
      type: false,
      mStatus: false,
    );
    await db!.collection("users").add(userData.toJson()).then(
        (DocumentReference doc) =>
            print('DocumentSnapshot added with ID: ${doc.id}'));
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      )
          .then(
        (value) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Weak Password"),
              content: Text("The password provided is too weak."),
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
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Email Already In Use"),
              content: Text("The account already exists for that email."),
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
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mituranga_project/components/text_component.dart';
import 'package:mituranga_project/models/admin_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/button_component.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool select1 = false;
  bool select2 = false;
  bool select3 = false;
  String? stringValue;

  List selectWeek = [];

  TextEditingController dayOneTitle = TextEditingController();
  TextEditingController dayOneWarmUp = TextEditingController();
  TextEditingController dayOneDrills = TextEditingController();
  TextEditingController dayOneMainSet = TextEditingController();
  TextEditingController dayOneCoolDown = TextEditingController();
  TextEditingController dayTwoTitle = TextEditingController();
  TextEditingController dayTwoWarmUp = TextEditingController();
  TextEditingController dayTwoDrills = TextEditingController();
  TextEditingController dayTwoCoolDown = TextEditingController();
  TextEditingController dayThreeTitle = TextEditingController();
  TextEditingController dayThreeDryland = TextEditingController();
  TextEditingController dayThreePool = TextEditingController();
  TextEditingController dayThreeCoolDown = TextEditingController();
  TextEditingController dayForeTitle = TextEditingController();
  TextEditingController dayFiveTitle = TextEditingController();
  TextEditingController dayFiveWarmUp = TextEditingController();
  TextEditingController dayFiveCoolDown = TextEditingController();
  TextEditingController daySixTitle = TextEditingController();
  TextEditingController daySixWarmUp = TextEditingController();
  TextEditingController daySixMainSet = TextEditingController();
  TextEditingController daySixCoolDown = TextEditingController();
  TextEditingController daySevenTitle = TextEditingController();

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
      appBar: AppBar(
        title: const Text("Admin Penal"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Lavel",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ChoiceChip(
                            label: const Text("Beginner Level"),
                            selected: select1,
                            selectedColor: Colors.green,
                            onSelected: (value) {
                              setState(() {
                                if (select2 || select3) {
                                  print("select 1");
                                } else {
                                  if (value) {
                                    select1 = value;
                                    stringValue = "Beginner Level";
                                    print(stringValue);
                                  } else {
                                    select1 = value;
                                    stringValue = "";
                                    print(stringValue);
                                  }
                                }
                              });
                            },
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ChoiceChip(
                            label: const Text("Intermediate Level"),
                            selected: select2,
                            selectedColor: Colors.green,
                            onSelected: (value) {
                              setState(() {
                                if (select1 || select3) {
                                  print("select 1");
                                } else {
                                  if (value) {
                                    select2 = value;
                                    stringValue = "Intermediate Level";
                                  } else {
                                    select2 = value;
                                    stringValue = "";
                                  }
                                }
                              });
                            },
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ChoiceChip(
                            label: const Text("Professional  Level"),
                            selected: select3,
                            selectedColor: Colors.green,
                            onSelected: (value) {
                              setState(() {
                                if (select1 || select2) {
                                  print("select 1");
                                } else {
                                  if (value) {
                                    select3 = value;
                                    stringValue = "Professional  Level";
                                  } else {
                                    select3 = value;
                                    stringValue = "";
                                  }
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Week Schedule",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Day 1",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              TextComponent(
                                  hintText: "Title",
                                  obscureText: false,
                                  controller: dayOneTitle,
                                  keyboardType: TextInputType.text),
                              TextComponent(
                                  hintText: "Warm Up",
                                  obscureText: false,
                                  controller: dayOneWarmUp,
                                  maxLines: 3,
                                  keyboardType: TextInputType.text),
                              TextComponent(
                                  hintText: "Drills",
                                  obscureText: false,
                                  controller: dayOneDrills,
                                  maxLines: 3,
                                  keyboardType: TextInputType.text),
                              TextComponent(
                                  hintText: "Main Set",
                                  obscureText: false,
                                  controller: dayOneMainSet,
                                  maxLines: 3,
                                  keyboardType: TextInputType.text),
                              TextComponent(
                                  hintText: "Cool Down",
                                  obscureText: false,
                                  controller: dayOneCoolDown,
                                  maxLines: 3,
                                  keyboardType: TextInputType.text)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Day 2",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              TextComponent(
                                  hintText: "Title",
                                  obscureText: false,
                                  controller: dayTwoTitle,
                                  keyboardType: TextInputType.text),
                              TextComponent(
                                  hintText: "Warm Up",
                                  obscureText: false,
                                  controller: dayTwoWarmUp,
                                  maxLines: 3,
                                  keyboardType: TextInputType.text),
                              TextComponent(
                                  hintText: "Drills",
                                  obscureText: false,
                                  controller: dayTwoDrills,
                                  maxLines: 3,
                                  keyboardType: TextInputType.text),
                              TextComponent(
                                  hintText: "Cool Down",
                                  obscureText: false,
                                  controller: dayTwoCoolDown,
                                  maxLines: 3,
                                  keyboardType: TextInputType.text)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Day 3",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              TextComponent(
                                  hintText: "Title",
                                  obscureText: false,
                                  controller: dayThreeTitle,
                                  keyboardType: TextInputType.text),
                              TextComponent(
                                  hintText: "Dryland",
                                  obscureText: false,
                                  controller: dayThreeDryland,
                                  maxLines: 3,
                                  keyboardType: TextInputType.text),
                              TextComponent(
                                  hintText: "Pool",
                                  obscureText: false,
                                  controller: dayThreePool,
                                  maxLines: 3,
                                  keyboardType: TextInputType.text),
                              TextComponent(
                                  hintText: "Cool Down",
                                  obscureText: false,
                                  controller: dayThreeCoolDown,
                                  maxLines: 3,
                                  keyboardType: TextInputType.text)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Day 4",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              TextComponent(
                                  hintText: "Title",
                                  obscureText: false,
                                  controller: dayForeTitle,
                                  keyboardType: TextInputType.text),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Day 5",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              TextComponent(
                                  hintText: "Title",
                                  obscureText: false,
                                  controller: dayFiveTitle,
                                  keyboardType: TextInputType.text),
                              TextComponent(
                                  hintText: "Warm-up",
                                  obscureText: false,
                                  controller: dayFiveWarmUp,
                                  maxLines: 3,
                                  keyboardType: TextInputType.text),
                              TextComponent(
                                  hintText: "Cool Down",
                                  obscureText: false,
                                  controller: dayFiveCoolDown,
                                  maxLines: 3,
                                  keyboardType: TextInputType.text)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Day 6",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              TextComponent(
                                  hintText: "Title",
                                  obscureText: false,
                                  controller: daySixTitle,
                                  keyboardType: TextInputType.text),
                              TextComponent(
                                  hintText: "Warm up",
                                  obscureText: false,
                                  controller: daySixWarmUp,
                                  maxLines: 3,
                                  keyboardType: TextInputType.text),
                              TextComponent(
                                  hintText: "Main Set",
                                  obscureText: false,
                                  controller: daySixMainSet,
                                  maxLines: 3,
                                  keyboardType: TextInputType.text),
                              TextComponent(
                                  hintText: "Cool Down",
                                  obscureText: false,
                                  controller: daySixCoolDown,
                                  maxLines: 3,
                                  keyboardType: TextInputType.text)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Day 7",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              TextComponent(
                                  hintText: "Title",
                                  obscureText: false,
                                  controller: daySevenTitle,
                                  keyboardType: TextInputType.text),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonComponent(
                buttonText: "Save",
                onTap: () {
                  scheduleMethod();
                }),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  void scheduleMethod() async {
    var userEmail = FirebaseAuth.instance.currentUser!.email;
    print(userEmail);
    AdminData admin = AdminData(
      email: userEmail,
      selectLevel: stringValue!.trim(),
      dayOneTitle: dayOneTitle.text.trim(),
      dayOneWarmUp: dayOneWarmUp.text.trim(),
      dayOneDrills: dayOneDrills.text.trim(),
      dayOneMainSet: dayOneMainSet.text.trim(),
      dayOneCoolDown: dayOneCoolDown.text.trim(),
      dayTwoTitle: dayTwoTitle.text.trim(),
      dayTwoWarmUp: dayTwoWarmUp.text.trim(),
      dayTwoDrills: dayTwoDrills.text.trim(),
      dayTwoCoolDown: dayTwoCoolDown.text.trim(),
      dayThreeTitle: dayThreeTitle.text.trim(),
      dayThreeDryland: dayThreeDryland.text.trim(),
      dayThreePool: dayThreePool.text.trim(),
      dayThreeCoolDown: dayThreeCoolDown.text.trim(),
      dayForeTitle: dayForeTitle.text.trim(),
      dayFiveTitle: dayFiveTitle.text.trim(),
      dayFiveWarmUp: dayFiveWarmUp.text.trim(),
      dayFiveCoolDown: dayFiveCoolDown.text.trim(),
      daySixTitle: daySixTitle.text.trim(),
      daySixWarmUp: daySixWarmUp.text.trim(),
      daySixMainSet: daySixMainSet.text.trim(),
      daySixCoolDown: daySixCoolDown.text.trim(),
      daySevenTitle: daySevenTitle.text.trim(),
      activeStatus: false,
    );
    await db!.collection("Schedule").add(admin.toJson()).then(
        (DocumentReference doc) =>
            print('DocumentSnapshot added with ID: ${doc.id}'));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mituranga_project/screens/auth/login_screen.dart';
import 'package:mituranga_project/screens/main/admin_dashboard.dart';
import 'package:mituranga_project/screens/main/histrory.dart';
import 'package:mituranga_project/screens/main/visible_screen.dart';

import 'chat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore? db;
  List tempList = [];
  bool? userType;
  bool loading = false;
  String? documentId;
  String? mainId;
  bool? mStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = FirebaseFirestore.instance;
    userLogin();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const History(),
                    ));
              },
              icon: const Icon(Icons.history_edu)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VisibleScreen(),
                    ));
              },
              icon: const Icon(Icons.edit_document)),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
              },
              icon: const Icon(Icons.logout_outlined)),
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            // Reload data when user pulls to refresh
            setState(() {
              loadData();
            });
           
          },
          child: FutureBuilder(
            future: loadData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("error"),
                );
              } else {
                return tempList.isEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/aaa.png"),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const VisibleScreen(),
                                  ));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 7),
                              decoration: BoxDecoration(
                                  color: Colors.blue.shade500,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text("SELECT YOUR TRAINING PLAN"),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        itemCount: tempList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        child: Text(
                                            tempList[index]["dayOneTitle"][0]),
                                      ),
                                      Text(
                                        "${tempList[index]["selectLevel"]}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            await db!
                                                .collection("Choices")
                                                .doc(mainId)
                                                .update({"status": false})
                                                .then(
                                              (value) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Training plan deactivated successfully.",
                                                    toastLength:
                                                        Toast.LENGTH_LONG);
                                                setState(() {});
                                              },
                                            ).catchError((error) =>
                                                    // ignore: invalid_return_type_for_catch_error
                                                    Fluttertoast.showToast(
                                                        msg: "$error",
                                                        toastLength:
                                                            Toast.LENGTH_LONG));
                                          },
                                          child: Text("Deactivate")),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue[200],
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Day One Schedule",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${tempList[index]["dayOneTitle"]}",
                                            style: TextStyle(
                                                color: Colors.blue[200],
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "${tempList[index]["dayOneWarmUp"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "${tempList[index]["dayOneDrills"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "${tempList[index]["dayOneMainSet"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "${tempList[index]["dayOneCoolDown"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    8.0), // Adjust the value as needed
                                            child: const Divider(
                                              color: Colors.blue,
                                              thickness: 1,
                                            ),
                                          ),
                                          // day 2
                                          Text(
                                            "Day Two Schedule",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${tempList[index]["dayTwoTitle"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "${tempList[index]["dayTwoWarmUp"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "${tempList[index]["dayTwoDrills"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),

                                          Text(
                                            "${tempList[index]["dayTwoCoolDown"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    8.0), // Adjust the value as needed
                                            child: const Divider(
                                              color: Colors.blue,
                                              thickness: 1,
                                            ),
                                          ),
                                          // day 3

                                          Text(
                                            "Day Three Schedule",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${tempList[index]["dayThreeTitle"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "${tempList[index]["dayThreeDryland"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "${tempList[index]["dayThreePool"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),

                                          Text(
                                            "${tempList[index]["dayThreeCoolDown"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),

                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    8.0), // Adjust the value as needed
                                            child: const Divider(
                                              color: Colors.blue,
                                              thickness: 1,
                                            ),
                                          ),
                                          // day 4

                                          Text(
                                            "Day Fore Schedule",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${tempList[index]["dayForeTitle"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),

                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    8.0), // Adjust the value as needed
                                            child: const Divider(
                                              color: Colors.blue,
                                              thickness: 1,
                                            ),
                                          ),
                                          // day 5

                                          Text(
                                            "Day Five Schedule",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${tempList[index]["dayFiveTitle"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "${tempList[index]["dayFiveWarmUp"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "${tempList[index]["dayFiveCoolDown"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    8.0), // Adjust the value as needed
                                            child: const Divider(
                                              color: Colors.blue,
                                              thickness: 1,
                                            ),
                                          ),
                                          // day 6

                                          Text(
                                            "Day Six Schedule",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${tempList[index]["daySixTitle"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "${tempList[index]["daySixWarmUp"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "${tempList[index]["daySixMainSet"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "${tempList[index]["daySixCoolDown"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    8.0), // Adjust the value as needed
                                            child: const Divider(
                                              color: Colors.blue,
                                              thickness: 1,
                                            ),
                                          ),
                                          // day 7

                                          Text(
                                            "Day Seven Schedule",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${tempList[index]["daySevenTitle"]}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
              }
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  chatStatus: mStatus!,
                  userType: userType!,
                ),
              ));
        },
        child: Icon(Icons.message),
      ),
    );
  }

  Future loadData() async {
    documentId = null;
    mainId = null;
    var planStatus = null;
    var userEmail = FirebaseAuth.instance.currentUser!.email;
    await db!.collection("Choices").get().then(
      (event) {
        for (var doc in event.docs) {
          if (doc.data()["email"] == userEmail) {
            if (doc.data()["status"] == true) {
              documentId = doc.data()["documentId"];
              planStatus = doc.data()["status"];
              mainId = doc.id;
              return;
              //print(documentId);
            }
          }
        }
      },
    ).catchError(
      (error, stackTrace) {
        print(error);
      },
    );
    if (documentId != null) {
      tempList.clear();
      await db!.collection("Schedule").doc(documentId).get().then((value) {
        if (planStatus) {
          tempList.add(value.data());
          // print(value.data());
        }
      });
    }
    await db!
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get()
        .then(
      (value) {
        for (var doc in value.docs) {
          mStatus = doc.data()["mStatus"];
          userType = doc.data()["type"];
          print("$mStatus $userType");
        }
      },
    );
  }

  void userLogin() async {
    await db!.collection("users").get().then((event) {
      for (var doc in event.docs) {
        if (doc.data()["email"] == FirebaseAuth.instance.currentUser!.email) {
          setState(() {
            userType = doc.data()["type"];
            loading = true;
            if (doc.data()["type"]) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminDashboard(),
                  ));
            }
          });
        }
      }
    }).onError(
      (error, stackTrace) {
        print(error);
      },
    );
  }

  // void viewDetails(int index) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text("WEEK SCHEDULE"),
  //         content: SingleChildScrollView(
  //           child:
  //         ),
  //         actions: [
  //           TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Text("Cancel")),
  //           TextButton(
  //               onPressed: () async {
  //                 await db!
  //                     .collection("Choices")
  //                     .doc(mainId)
  //                     .update({"status": false})
  //                     .then((value) => Fluttertoast.showToast(
  //                         msg: "Update Success",
  //                         toastLength: Toast.LENGTH_LONG))
  //                     .catchError((error) => Fluttertoast.showToast(
  //                         msg: "$error", toastLength: Toast.LENGTH_LONG));
  //               },
  //               child: Text("Deactivate"))
  //         ],
  //       );
  //     },
  //   );
  // }
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

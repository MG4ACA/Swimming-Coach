import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mituranga_project/screens/main/admin_screen.dart';
import 'package:mituranga_project/screens/main/message.dart';
import 'package:mituranga_project/screens/main/visible_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore? db;
  List tempList = [];
  bool userType = false;

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
        title: const Text("Home"),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout_outlined)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VisibleScreen(),
                    ));
              },
              icon: const Icon(Icons.more_vert_outlined)),
          userType
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminScreen(),
                        ));
                  },
                  icon: const Icon(Icons.admin_panel_settings_outlined))
              : const SizedBox(),
        ],
      ),
      body: FutureBuilder(
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
                      Text(
                        "Choose your plan",
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
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
                              border: Border.all(width: 1),
                              color: Colors.green.shade500,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text("Choose"),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: tempList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: Colors.black38)),
                          leading: CircleAvatar(
                            child: Text(tempList[index]["selectLevel"][0]
                                .toString()
                                .toUpperCase()),
                          ),
                          title: Text("${tempList[index]["selectLevel"]}"),
                          trailing: IconButton(
                              onPressed: () {
                                viewDetails(index);
                              },
                              icon: Icon(Icons.view_compact_sharp)),
                          subtitleTextStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          titleTextStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MessageScreen(),
              ));
        },
        child: Icon(Icons.message),
      ),
    );
  }

  Future loadData() async {
    tempList.clear();
    var userEmail = FirebaseAuth.instance.currentUser!.email;
    await db!.collection("Choices").get().then((event) {
      for (var doc in event.docs) {
        if (doc.data()["userEmail"] == userEmail) {
          tempList.add(doc.data());
        }
      }
    });
    await db!.collection("users").get().then((event) {
      for (var doc in event.docs) {
        if (doc.data()["email"] == userEmail) {
          userType = doc.data()["type"];
        }
      }
    });
  }

  void viewDetails(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("WEEK SCHEDULE"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Day One Schedule",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${tempList[index]["dayOneTitle"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList[index]["dayOneWarmUp"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList[index]["dayOneDrills"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList[index]["dayOneMainSet"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList[index]["dayOneCoolDown"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const Divider(
                  thickness: 2,
                ),
                // day 2

                Text(
                  "Day Two Schedule",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${tempList[index]["dayTwoTitle"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList[index]["dayTwoWarmUp"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList[index]["dayTwoDrills"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),

                Text(
                  "${tempList[index]["dayTwoCoolDown"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const Divider(
                  thickness: 2,
                ),
                // day 3

                Text(
                  "Day Three Schedule",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${tempList[index]["dayThreeTitle"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList[index]["dayThreeDryland"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList[index]["dayThreePool"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),

                Text(
                  "${tempList[index]["dayThreeCoolDown"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),

                const Divider(
                  thickness: 2,
                ),
                // day 4

                Text(
                  "Day Fore Schedule",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${tempList[index]["dayForeTitle"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),

                const Divider(
                  thickness: 2,
                ),
                // day 5

                Text(
                  "Day Five Schedule",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${tempList[index]["dayFiveTitle"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList[index]["dayFiveWarmUp"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList[index]["dayFiveCoolDown"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),

                const Divider(
                  thickness: 2,
                ),
                // day 6

                Text(
                  "Day Six Schedule",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${tempList[index]["daySixTitle"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList[index]["daySixWarmUp"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList[index]["daySixMainSet"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList[index]["daySixCoolDown"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),

                const Divider(
                  thickness: 2,
                ),
                // day 7

                Text(
                  "Day Seven Schedule",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${tempList[index]["daySevenTitle"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
            TextButton(
                onPressed: () async {
                  await db!.collection("Schedule");
                },
                child: Text("Delete"))
          ],
        );
      },
    );
  }
}

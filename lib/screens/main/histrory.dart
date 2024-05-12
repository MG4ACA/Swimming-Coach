import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mituranga_project/screens/auth/login_screen.dart';
import 'package:mituranga_project/screens/main/admin_screen.dart';
import 'package:mituranga_project/screens/main/message.dart';
import 'package:mituranga_project/screens/main/visible_screen.dart';

import 'chat.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  FirebaseFirestore? db;
  List tempList1 = [];
  bool userType = false;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = FirebaseFirestore.instance;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
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
            return tempList1.isEmpty
                ? Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 100,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "History",
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
                          child: const SizedBox(),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: tempList1.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: Colors.black38)),
                          leading: CircleAvatar(
                            child: Text(tempList1[index]["selectLevel"][0]
                                .toString()
                                .toUpperCase()),
                          ),
                          title: Text("${tempList1[index]["selectLevel"]}"),
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
                builder: (context) => ChatScreen(),
              ));
        },
        child: Icon(Icons.message),
      ),
    );
  }

  Future loadData() async {
    tempList1.clear();
    var userEmail = FirebaseAuth.instance.currentUser!.email;
    await db!.collection("Choices").get().then((event) {
      for (var doc in event.docs) {
        if (doc.data()["userEmail"] == userEmail) {
          if (doc.data()["activeStatus"] == false) {
            tempList1.add(doc.data());
          }
        }
      }
    }).onError(
      (error, stackTrace) {
        print(error);
      },
    );
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
                  "${tempList1[index]["dayOneTitle"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList1[index]["dayOneWarmUp"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList1[index]["dayOneDrills"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList1[index]["dayOneMainSet"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList1[index]["dayOneCoolDown"]}",
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
                  "${tempList1[index]["dayTwoTitle"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList1[index]["dayTwoWarmUp"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList1[index]["dayTwoDrills"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),

                Text(
                  "${tempList1[index]["dayTwoCoolDown"]}",
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
                  "${tempList1[index]["dayThreeTitle"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList1[index]["dayThreeDryland"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList1[index]["dayThreePool"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),

                Text(
                  "${tempList1[index]["dayThreeCoolDown"]}",
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
                  "${tempList1[index]["dayForeTitle"]}",
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
                  "${tempList1[index]["dayFiveTitle"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList1[index]["dayFiveWarmUp"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList1[index]["dayFiveCoolDown"]}",
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
                  "${tempList1[index]["daySixTitle"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList1[index]["daySixWarmUp"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList1[index]["daySixMainSet"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${tempList1[index]["daySixCoolDown"]}",
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
                  "${tempList1[index]["daySevenTitle"]}",
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

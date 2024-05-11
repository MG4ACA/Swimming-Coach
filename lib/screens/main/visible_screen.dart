import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mituranga_project/models/add.dart';
import 'package:mituranga_project/models/admin_data.dart';

class VisibleScreen extends StatefulWidget {
  const VisibleScreen({super.key});

  @override
  State<VisibleScreen> createState() => _VisibleScreenState();
}

class _VisibleScreenState extends State<VisibleScreen> {
  final item5 = ["Beginner Level", "Intermediate Level", "Professional  Level"];
  List<Map<String, dynamic>> tempList = [];
  List docId = [];
  String? selectLevel;
  FirebaseFirestore? db;
  bool schedule = false;

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
        title: Text("You are Choices Plan"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton(
                  underline: const SizedBox(),
                  isExpanded: true,
                  iconSize: 40,
                  hint: const Text('Select Level'),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                  ),
                  value: selectLevel,
                  items: item5.map(buildMenuItem5).toList(),
                  onChanged: (value) => setState(() {
                    selectLevel = value;
                    tempList.clear();
                  }),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            flex: 15,
            child: selectLevel != null
                ? FutureBuilder(
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
                        return ListView.builder(
                          itemCount: tempList.length,
                          itemBuilder: (context, index) {
                            var id = docId[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8),
                                shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(color: Colors.black38)),
                                leading: Checkbox(
                                  value: tempList[index]["activeStatus"],
                                  onChanged: (value) {
                                    setState(() {
                                      tempList[index]["activeStatus"] = value!;
                                      update(value, id, index);
                                      tempList.clear();
                                    });
                                  },
                                ),
                                title:
                                    Text("${tempList[index]["dayOneTitle"]}"),
                                subtitle: Text(
                                  "${tempList[index]["dayOneWarmUp"]}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem5(String items5) => DropdownMenuItem(
        value: items5,
        child: Text(items5),
      );

  Future loadData() async {
    await db!.collection("Schedule").get().then((event) {
      for (var doc in event.docs) {
        if (doc.data()["selectLevel"] == selectLevel) {
          AdminData.fromJson(doc.data());
          tempList.add(doc.data());
          docId.add(doc.id);
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
                child: Text("Cancel"))
          ],
        );
      },
    );
  }

  void update(bool value, String docI, int index) async {
    var userE = FirebaseAuth.instance.currentUser!.email;
    await db!.collection("Schedule").doc("$docI").update({
      "activeStatus": value,
    }).then((values) async {
      if (value) {
        AdminData admin = AdminData(
          token: "",
          email: FirebaseAuth.instance.currentUser!.email,
          selectLevel: tempList[index]["selectLevel"],
          dayOneTitle: tempList[index]["dayOneTitle"],
          dayOneWarmUp: tempList[index]["dayOneWarmUp"],
          dayOneDrills: tempList[index]["dayOneDrills"],
          dayOneMainSet: tempList[index]["dayOneMainSet"],
          dayOneCoolDown: tempList[index]["dayOneCoolDown"],
          dayTwoTitle: tempList[index]["dayTwoTitle"],
          dayTwoWarmUp: tempList[index]["dayTwoWarmUp"],
          dayTwoDrills: tempList[index]["dayTwoDrills"],
          dayTwoCoolDown: tempList[index]["dayTwoCoolDown"],
          dayThreeTitle: tempList[index]["dayThreeTitle"],
          dayThreeDryland: tempList[index]["dayThreeDryland"],
          dayThreePool: tempList[index]["dayThreePool"],
          dayThreeCoolDown: tempList[index]["dayThreeCoolDown"],
          dayForeTitle: tempList[index]["dayForeTitle"],
          dayFiveTitle: tempList[index]["dayFiveTitle"],
          dayFiveWarmUp: tempList[index]["dayFiveWarmUp"],
          dayFiveCoolDown: tempList[index]["dayFiveCoolDown"],
          daySixTitle: tempList[index]["daySixTitle"],
          daySixWarmUp: tempList[index]["daySixWarmUp"],
          daySixMainSet: tempList[index]["daySixMainSet"],
          daySixCoolDown: tempList[index]["daySixCoolDown"],
          daySevenTitle: tempList[index]["daySevenTitle"],
          activeStatus: true,
        );
        await db!.collection("Choices").add(admin.toJson()).then(
              (value) {},
            );
      } else {}
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mituranga_project/models/add.dart';

class VisibleScreen extends StatefulWidget {
  const VisibleScreen({super.key});

  @override
  State<VisibleScreen> createState() => _VisibleScreenState();
}

class _VisibleScreenState extends State<VisibleScreen> {
  final item5 = ["Beginner Level", "Intermediate Level", "Professional  Level"];
  List tempList = [];
  List tempList2 = [];
  List docId = [];
  String? selectLevel;
  FirebaseFirestore? db;
  bool? selectSchedule = false;
  bool? checkSchedule;
  String? planDocId;

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
        title: Text("Choose your training plan"),
      ),
      body: Column(
        children: [
          // const Text(
          //   "Whether you're a beginner dipping your toes into the world of swimming, an intermediate swimmer looking to refine your techniques and endurance, or an experienced swimmer ready to tackle advanced strokes and competitive strategie",
          //   style: TextStyle(color: Colors.black),
          // ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.bottomCenter,
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
                    selectLevel = "";
                    selectLevel = value;
                    print(selectLevel);
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
            child: Container(
              child: selectLevel != null
                  ? FutureBuilder(
                      future: loadData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text("system Error"),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: tempList.length,
                            itemBuilder: (context, index) {
                              dynamic id = docId[index];

                              checkData(id);
                              return ListTile(
                                leading: Checkbox(
                                  value: checkSchedule! && selectSchedule!
                                      ? true
                                      : false,
                                  onChanged: (value) {
                                    if (selectSchedule!) {
                                      Fluttertoast.showToast(
                                          msg: "You already have a plan",
                                          toastLength: Toast.LENGTH_LONG);
                                    } else {
                                      setState(() {});
                                    }
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
                                      viewDetails(index, id);
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
                              );
                            },
                          );
                        }
                      },
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Image.asset("assets/images/aaa.png"),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Choice you are plan",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
            ),
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
    tempList.clear();
    tempList2.clear();
    docId.clear();
    await db!.collection("Choices").get().then(
      (value) async {
        for (var doc in value.docs) {
          if (doc.data()["email"] == FirebaseAuth.instance.currentUser!.email) {
            if (doc.data()["status"] == true) {
              selectSchedule = true;
              planDocId = doc.id;
              tempList2.add("${doc.data()["documentId"]}");
            }
          } else {}
        }
      },
    );
    await db!.collection("Schedule").get().then(
      (value) async {
        for (var doc in value.docs) {
          if (doc.data()["selectLevel"] == selectLevel) {
            tempList.add(doc.data());
            docId.add(doc.id);
            // print("${doc.id}");
          }
        }
      },
    );
  }

  Future checkData(dynamic id) async {
    var c = tempList2.contains(id);
    if (c) {
      checkSchedule = true;
    } else {
      checkSchedule = false;
      //print("A $id");
    }
  }

  void viewDetails(int index, String id) {
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
            selectSchedule!
                ? TextButton(
                    onPressed: () async {
                      await db!
                          .collection("Choices")
                          .doc(planDocId)
                          .update({"status": false})
                          .then((_) => Fluttertoast.showToast(
                              msg: "Training plan deactivated successfully.",
                              toastLength: Toast.LENGTH_LONG))
                          .catchError((error) => Fluttertoast.showToast(
                              msg: "$error", toastLength: Toast.LENGTH_LONG));
                      setState(() {
                        Navigator.pop(context);
                        selectSchedule = false;
                      });
                    },
                    child: Text("Deactivate"))
                : TextButton(
                    onPressed: () async {
                      print(planDocId);
                      AddSchedule ad = AddSchedule(
                        email: FirebaseAuth.instance.currentUser!.email,
                        documentId: id,
                        status: true,
                      );
                      await db!
                          .collection("Choices")
                          .add(ad.toJson())
                          .then((_) => Fluttertoast.showToast(
                              msg: "Success", toastLength: Toast.LENGTH_LONG))
                          .catchError((error) => Fluttertoast.showToast(
                              msg: "$error", toastLength: Toast.LENGTH_LONG));
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Text("Activate")),
          ],
        );
      },
    );
  }
}

// class CheckIndex extends StatelessWidget {
//   final int? checkIndex;
//   const CheckIndex({super.key, required this.checkIndex});

//   @override
//   Widget build(BuildContext context) {
//     bool? check;
//     return const Placeholder();
//   }
// }

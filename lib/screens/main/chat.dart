import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_screen.dart';

class ChatScreen extends StatefulWidget {
  final bool chatStatus;
  final bool userType;
  const ChatScreen(
      {super.key, required this.chatStatus, required this.userType});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _message = TextEditingController();
  var userDetail = {};

  FirebaseFirestore? db;

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
    loadUserData();
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      String userName = userDetail["fullName"];
      Map<String, dynamic> message = {
        "send": FirebaseAuth.instance.currentUser!.email,
        "message": _message.text,
        "time": FieldValue.serverTimestamp(),
        "userName": userName.split(" ")[0]
      };
      await db?.collection("ChatRoom").add(message);

      _message.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Community Chat"),
          centerTitle: true,
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => HomeScreen(),
        //         ));
        //   },
        //   child: Icon(Icons.arrow_back),
        // ),
        body: widget.chatStatus
            ? SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 1.28,
                      width: MediaQuery.of(context).size.width,
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
                      child: StreamBuilder<QuerySnapshot>(
                        stream: db
                            ?.collection("ChatRoom")
                            .orderBy("time", descending: false)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.data != null) {
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                dynamic map = snapshot.data!.docs[index].data();
                                return message(map, index);
                              },
                            );
                          } else {
                            return Text("Error");
                          }
                        },
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 10,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 12,
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height / 12,
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: TextField(
                                  controller: _message,
                                  decoration: InputDecoration(
                                      hintText: "send Message",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                ),
                              ),
                              IconButton(
                                  onPressed: onSendMessage,
                                  icon: Icon(Icons.send))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Cannot Access Community Chat!",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "You do not have permission to access the community chat. Please contact the administrator for assistance.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    )
                  ])));
  }

  Widget message(Map<String, dynamic> map, int index) {
    return Container(
      width: double.infinity,
      alignment: map["send"] == FirebaseAuth.instance.currentUser!.email
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
            color: map["send"] == FirebaseAuth.instance.currentUser!.email
                ? HexColor('#99e9de')
                : HexColor("#0440a0"),
            borderRadius: BorderRadius.circular(4)),
        child: map["send"] == FirebaseAuth.instance.currentUser!.email
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${map["userName"]} \n${map["message"]}",
                    style: TextStyle(
                        color: map["send"] ==
                                FirebaseAuth.instance.currentUser!.email
                            ? Colors.black
                            : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  // Text(
                  //   "${map["message"]}",
                  //   style: TextStyle(
                  //       color: map["send"] ==
                  //               FirebaseAuth.instance.currentUser!.email
                  //           ? Colors.black
                  //           : Colors.white,
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w500),
                  // ),
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                      child: Icon(
                    Icons.person,
                    size: 30,
                  )),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.userType!
                      ? InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Block User"),
                                  content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          child: Icon(
                                            Icons.person,
                                            size: 30,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Block user from community chat ?",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "User name: ${map["userName"]} \nEmail: ${map["send"]}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ]),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          await db
                                              ?.collection("users")
                                              .where("email",
                                                  isEqualTo: map["send"])
                                              .get()
                                              .then(
                                            (value) async {
                                              for (var doc in value.docs) {
                                                var docId = doc.id;
                                                await db
                                                    ?.collection("users")
                                                    .doc(docId)
                                                    .update({
                                                  "mStatus": false
                                                }).then(
                                                  (value) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "User blocked successfully.",
                                                        toastLength:
                                                            Toast.LENGTH_LONG);
                                                    setState(() {
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                ).catchError((error) {
                                                  Fluttertoast.showToast(
                                                      msg: "$error",
                                                      toastLength:
                                                          Toast.LENGTH_LONG);
                                                });
                                              }
                                            },
                                          ).catchError((error) {
                                            Fluttertoast.showToast(
                                                msg: "$error",
                                                toastLength: Toast.LENGTH_LONG);
                                          });
                                        },
                                        child: Text("Block"))
                                  ],
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                              child: Icon(
                            Icons.person,
                            size: 30,
                          )
                              // child: Text(map["send"] ==
                              //         FirebaseAuth.instance.currentUser!.email
                              //     ? map["send"][0]
                              //     : map["send"][0])
                              ),
                        )
                      : CircleAvatar(
                          child: Icon(
                          Icons.person,
                          size: 30,
                        )),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${map["userName"]} \n${map["message"]}",
                    style: TextStyle(
                        color: map["send"] ==
                                FirebaseAuth.instance.currentUser!.email
                            ? Colors.black
                            : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  // Text(
                  //   "${map["message"]}",
                  //   style: TextStyle(
                  //       color: map["send"] ==
                  //               FirebaseAuth.instance.currentUser!.email
                  //           ? Colors.black
                  //           : Colors.white,
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w500),
                  // ),
                ],
              ),
      ),
    );
  }

  void loadUserData() {
    db!
        .collection("users")
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get()
        .then(
      (QuerySnapshot<Map<String, dynamic>> event) {
        userDetail = event.docs[0].data();
      },
    ).catchError(
      (error, stackTrace) {
        print(error);
      },
    );
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

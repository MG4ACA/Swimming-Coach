import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mituranga_project/screens/main/chat.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  FirebaseFirestore? db;
  List userList = [];
  List docId = [];

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
          title: Text("Chat Space"),
        ),
        body: FutureBuilder(
          future: userDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error"),
              );
            } else {
              return userList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.message_outlined,
                            size: 100,
                            color: Colors.black,
                          ),
                          Text(
                            "User is empty!",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        var id = docId[index];
                        print(id);
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      name: userList[index]["fullName"],
                                      chatRoomId: id,
                                    ),
                                  ));
                            },
                            contentPadding: const EdgeInsets.all(2),
                            shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide.none),
                            leading: CircleAvatar(
                              radius: 40,
                              child: Text(userList[index]["fullName"][0]
                                  .toString()
                                  .toUpperCase()),
                            ),
                            title: Text(userList[index]["fullName"]
                                .toString()
                                .toUpperCase()),
                            titleTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        );
                      },
                    );
            }
          },
        ));
  }

  Future userDetails() async {
    var userEmail = FirebaseAuth.instance.currentUser!.email;
    await db!.collection("users").get().then(
      (event) {
        for (var doc in event.docs) {
          if (doc.data()["email"] == userEmail) {
          } else {
            userList.add(doc.data());
            docId.add(doc.id);
            print(doc.id);
          }
        }
      },
    );
  }
}

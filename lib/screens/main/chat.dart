import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String? name;
  final String? chatRoomId;
  ChatScreen({super.key, this.name, this.chatRoomId});

  TextEditingController _message = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> message = {
        "send": FirebaseAuth.instance.currentUser!.email,
        "message": _message.text,
        "time": FieldValue.serverTimestamp(),
      };
      await db
          .collection("ChatRoom")
          .doc("$chatRoomId")
          .collection("chats")
          .add(message);

      _message.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$name"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: db
                    .collection("ChatRoom")
                    .doc("$chatRoomId")
                    .collection("chats")
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        dynamic map = snapshot.data!.docs[index].data();
                        return message(map);
                      },
                    );
                  } else {
                    return Text("Error");
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height / 10,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
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
                          borderRadius: BorderRadius.circular(8))),
                ),
              ),
              IconButton(onPressed: onSendMessage, icon: Icon(Icons.send))
            ],
          ),
        ),
      ),
    );
  }

  Widget message(Map<String, dynamic> map) {
    return Container(
      width: double.infinity,
      alignment: map["send"] == FirebaseAuth.instance.currentUser!.email
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(4)),
        child: Text(
          map["message"],
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _message = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> message = {
        "send": FirebaseAuth.instance.currentUser!.email,
        "message": _message.text,
        "time": FieldValue.serverTimestamp(),
      };
      await db.collection("ChatRoom").add(message);

      _message.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Chat"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.28,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: db
                    .collection("ChatRoom")
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
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                      ),
                      IconButton(
                          onPressed: onSendMessage, icon: Icon(Icons.send))
                    ],
                  ),
                ),
              ),
            ),
          ],
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
            color: map["send"] == FirebaseAuth.instance.currentUser!.email
                ? Colors.white
                : Colors.green,
            borderRadius: BorderRadius.circular(4)),
        child: map["send"] == FirebaseAuth.instance.currentUser!.email
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${map["message"]}",
                    style: TextStyle(
                        color: map["send"] ==
                                FirebaseAuth.instance.currentUser!.email
                            ? Colors.black
                            : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                      child: Icon(map["send"] ==
                              FirebaseAuth.instance.currentUser!.email
                          ? Icons.person
                          : Icons.person_outlined)),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                      child: Icon(map["send"] ==
                              FirebaseAuth.instance.currentUser!.email
                          ? Icons.person
                          : Icons.person_outlined)),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${map["message"]}",
                    style: TextStyle(
                        color: map["send"] ==
                                FirebaseAuth.instance.currentUser!.email
                            ? Colors.black
                            : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
      ),
    );
  }
}

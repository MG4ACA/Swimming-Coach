import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mituranga_project/screens/auth/login_screen.dart';
import 'package:mituranga_project/screens/main/admin_screen.dart';
import 'package:mituranga_project/screens/main/chat.dart';

// Assuming you have separate Dart files for each page (e.g., page1.dart, page2.dart, etc.)
// import 'page1.dart';
// import 'page2.dart';
// import 'page3.dart';
// import 'page4.dart';

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  FirebaseFirestore? db;
  bool? userType;
  bool? mStatus;
  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // Logout icon
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ));
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: userData(),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300.0, // Adjust width as needed
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminScreen()),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('ADD NEW TRAINING PLAN'),
                    ),
                  ),
                  SizedBox(
                    width: 300.0, // Adjust width as needed
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                  chatStatus: mStatus!,
                                  userType: userType!,
                                )),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('MANAGE CHAT ROOM'),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future userData() async {
    await db!
        .collection("users")
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
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
}

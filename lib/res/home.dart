import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remote/auth/auth.dart';
import 'package:remote/pages/cardDetail.dart';
import 'package:remote/pages/loading.dart';
import 'package:remote/pages/register.dart';
import 'package:remote/res/appBar.dart';
import 'package:remote/res/btn.dart';
import 'package:remote/res/inp.dart';
import 'package:remote/res/nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  friendSystem test = friendSystem();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: homeAppBar("Home", context),
        backgroundColor: Color(4279243537),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(userAuth.currentUser!.uid)
              .collection("devices")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingPage();
            } else {
              return Padding(
                  padding: EdgeInsets.only(left: 15, right: 20, top: 5),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, pos) {
                        final cardData = snapshot.data!.docs[pos].data();
                        return Padding(
                            padding: EdgeInsets.only(left: 5, bottom: 5),
                            child: Container(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      textColor: Colors.white,
                                      title: Text(cardData["name"]),
                                      subtitle: Text(
                                        cardData["deviceIp"],
                                        style: TextStyle(color: Colors.white38),
                                      ),
                                      onTap: () => nav(
                                          context,
                                          CardDetailPage(
                                              path: cardData["userId"],
                                              name: cardData["name"],
                                              id: snapshot.data!.docs[pos].id)),
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: TextButton(
                                          child: Icon(
                                            Icons.share,
                                            color: Colors.white54,
                                          ),
                                          onPressed: () => test.searchDevices(
                                              context, cardData),
                                        ),
                                      ))
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Color(cardData["color"]),
                                  borderRadius: BorderRadius.circular(5)),
                            ));
                      }));
            }
          },
        ));
  }

  Widget deleteButton() {
    return btn("Delete Device", Icons.delete, () {
      FirebaseAuth auth = FirebaseAuth.instance;
      auth.currentUser!.delete().then((value) {
        nav(context, RegisterPage());
      });
    });
  }
}

// \n
// kann man gut mit mac gebrauchen
class friendSystem {
  void showSettings(context) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userAuth.currentUser!.uid)
        .get()
        .then((value) {
      final userData = value.data();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Color(4279243537),
              title: Text(
                "About",
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                  "uuid: " +
                      userData?["userId"] +
                      "\ndcid(deviceID): " +
                      userData?["deviceIp"] +
                      "\npath: " +
                      userData?["path"],
                  style: TextStyle(
                    color: Colors.white38,
                  )),
              actions: [
                TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Color(4279243537),
                              title: Text(
                                "Delete your Account",
                                style: TextStyle(color: Colors.white),
                              ),
                              content: Text(
                                "Are you sure?",
                                style: TextStyle(color: Colors.white38),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.redAccent),
                                    )),
                                TextButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(userAuth.currentUser!.uid)
                                          .delete()
                                          .then((value) {
                                        userAuth.currentUser!.delete();
                                      }).then((value) {
                                        nav(context, RegisterPage());
                                      });
                                    },
                                    child: Text(
                                      "Yes",
                                      style:
                                          TextStyle(color: Colors.greenAccent),
                                    ))
                              ],
                            );
                          });
                    },
                    child: Text(
                      "Delete Account",
                      style: TextStyle(color: Colors.redAccent),
                    )),
                TextButton(
                    onPressed: () {
                      FilePicker.platform.getDirectoryPath().then((value) {
                        final newPath = <String, dynamic>{"path": value};
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(userAuth.currentUser!.uid)
                            .update(newPath)
                            .then((value) {
                          Navigator.pop(context);
                        });
                      });
                    },
                    child: Text("Change your Path"))
              ],
            );
          });
    });
  }

  void createResp() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userAuth.currentUser!.uid)
        .get()
        .then((value) {
      final userData = value.data();
      final deviceData = <String, dynamic>{
        "userId": userData!["userId"],
        "deviceIp": userData["deviceIp"],
        "requestId": "own",
        "color": Color(0xFF2A2A2A).value,
        "name": "Own Respority"
      };
      FirebaseFirestore.instance
          .collection("users")
          .doc(userAuth.currentUser!.uid)
          .collection("devices")
          .doc(userData["deviceIp"])
          .set(deviceData);
    });
  }

  void searchDevices(context, cardData) {
    TextEditingController deviceIp = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, ss) {
            return AlertDialog(
              backgroundColor: Color(0xFF101311),
              title: Text(
                "Share with",
                style: TextStyle(color: Colors.white),
              ),
              content: deviceInp(deviceIp, "The Device Ip", Icons.search),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.redAccent),
                    )),
                TextButton(
                    onPressed: () =>
                        searchfor(deviceIp.text, cardData, context),
                    child: Text(
                      "Share",
                      style: TextStyle(color: Colors.greenAccent),
                    ))
              ],
            );
          });
        });
  }

  void searchfor(deviceIp, cardData, context) {
    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(userAuth.currentUser!.uid)
          .get()
          .then((user) {
        final userData = user.data();
        FirebaseFirestore.instance
            .collection("users")
            .where("deviceIp", isEqualTo: deviceIp)
            .get()
            .then((value) {
          print(userData!["deviceIp"]);
          if (deviceIp != userData!["deviceIp"] &&
              deviceIp != cardData["deviceIp"]) {
            try {
              final recUser = value.docs[0].data();
              final friendData = <String, dynamic>{
                "deviceIp": cardData["deviceIp"],
                "userId": cardData["userId"],
                "from": userData["userId"]
              };
              try {
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(recUser["userId"])
                    .collection("request")
                    .add(friendData)
                    .then((valueTest) {
                  Navigator.pop(context);
                });
              } on TimeoutException catch (e) {
                Navigator.pop(context);
                final internetSB = SnackBar(
                    content: Text(
                        "Timeout, your Device cant get any connection to the server"));
                ScaffoldMessenger.of(context).showSnackBar(internetSB);
              }
              print(value.docs[0].data()["userId"]);
            } on RangeError catch (e) {
              Navigator.pop(context);
              final noFoundSB = SnackBar(
                  content: Text("We couldnt find this DVID(" +
                      deviceIp +
                      ") in our system, please try again and look if you typed it correctly or if your connection is stable"));
              ScaffoldMessenger.of(context).showSnackBar(noFoundSB);
            }
          } else {
            Navigator.pop(context);
            final notselfSB =
                SnackBar(content: Text("You cant use your own DVID"));
            ScaffoldMessenger.of(context).showSnackBar(notselfSB);
          }
        });
      });
    } on TimeoutException catch (e) {
      Navigator.pop(context);
      final internetSB = SnackBar(
          content: Text(
              "Timeout, your Device cant get any connection to the server"));
      ScaffoldMessenger.of(context).showSnackBar(internetSB);
    }
  }
}

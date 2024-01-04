import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:remote/auth/auth.dart';
import 'package:remote/pages/loading.dart';
import 'package:remote/res/appBar.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar("Your Requests"),
      backgroundColor: Color(0xFF101311),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(userAuth.currentUser!.uid)
            .collection("request")
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.active) {
            return ListView.builder(
                itemCount: snap.data!.docs.length,
                itemBuilder: (context, pos) {
                  final cardData = snap.data!.docs[pos].data();
                  return Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Card(
                        color: Color(0xFF2A2A2A),
                        child: ListTile(
                            trailing: TextButton(
                                onPressed: () => acceptRequest(
                                    cardData["userId"],
                                    snap.data!.docs[pos].id,
                                    cardData),
                                child: Icon(Icons.done)),
                            textColor: Colors.white,
                            subtitle: Text(
                              "uuid: " + cardData["userId"],
                              style: TextStyle(color: Colors.white38),
                            ),
                            title:
                                Text("Request from: " + cardData["deviceIp"])),
                      ));
                });
          } else {
            return LoadingPage();
          }
        },
      ),
    );
  }

  void acceptRequest(auth, id, cardData) {
    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(userAuth.currentUser!.uid)
          .get()
          .then((value) {
        final userData = value.data();
        final deviceData = <String, dynamic>{
          "userId": cardData!["userId"],
          "deviceIp": cardData["deviceIp"],
          "from": cardData["from"],
          "color": Color(0xFF2A2A2A).value,
          "name": "none"
        };
        FirebaseFirestore.instance
            .collection("users")
            .doc(userAuth.currentUser!.uid)
            .collection("devices")
            .doc(cardData["deviceIp"])
            .set(deviceData)
            .then((value) {
          setState(() {
            FirebaseFirestore.instance
                .collection("users")
                .doc(userAuth.currentUser!.uid)
                .collection("request")
                .doc(id)
                .delete();
          });
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

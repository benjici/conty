import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:remote/res/btn.dart';
import 'package:remote/res/inp.dart';
import 'package:remote/res/snackbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController deviceMail = TextEditingController();
  TextEditingController devicePass = TextEditingController();
  int deviceIp = Random().nextInt(1000000000);
  String path = "none";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101311),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.white38, width: 1.5)),
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: 11, left: 20, right: 20, top: 11),
                child: Row(
                  children: [
                    SelectableText(
                      deviceIp.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 40),
                        child: Text(
                          "@device.ip",
                          style: TextStyle(color: Colors.white30, fontSize: 20),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          child: Icon(Icons.copy),
                          onPressed: () async {
                            await Clipboard.setData(
                                    ClipboardData(text: deviceIp.toString()))
                                .then((value) {
                              snackBar(
                                  deviceIp.toString() + " copied to clipboard",
                                  context);
                            });
                            // copied successfully
                          },
                        )),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          child: Icon(Icons.refresh),
                          onPressed: () {
                            setState(() {
                              deviceIp = Random().nextInt(1000000000);
                            });
                          },
                        ))
                  ],
                ),
              ),
            ),
          ),
          inp(devicePass, "Your Device Password", Icons.password),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: btn("Your downloading Directory", Icons.folder, () {
              FilePicker.platform.getDirectoryPath().then((value) {
                path = value!;
              });
            }),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: btn("Register this Device", Icons.person_add, () {
              register();
            }),
          )
        ],
      ),
    );
  }

  void register() {
    print("erw");
    print("erw");
    print("erw");
    print("erw    print();c");
    print("erw");
    print("erw");
    if (deviceIp.toString().isNotEmpty &&
        devicePass.text.toString().isNotEmpty &&
        path != "none") {
      FirebaseAuth auth = FirebaseAuth.instance;
      auth
          .createUserWithEmailAndPassword(
              email: deviceIp.toString() + "@device.ip",
              password: devicePass.text)
          .then((value) {
        final userData = <String, dynamic>{
          "deviceIp": deviceIp.toString(),
          "userId": auth.currentUser!.uid,
          "path": path
        };
        FirebaseFirestore.instance
            .collection("users")
            .doc(auth.currentUser!.uid)
            .set(userData);
      });
    }
  }
}

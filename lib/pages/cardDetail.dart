import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remote/auth/auth.dart';
import 'package:remote/pages/loading.dart';
import 'package:remote/res/appBar.dart';
import 'package:remote/res/btn.dart';
import 'package:remote/res/snackbar.dart';

class CardDetailPage extends StatefulWidget {
  CardDetailPage(
      {super.key, required this.path, required this.name, required this.id});
  String path = "";
  String name = "";
  String id = "";
  @override
  State<CardDetailPage> createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> {
  bool picking = false;

  @override
  Widget build(BuildContext context) {
    Future<ListResult> futurefiles =
        FirebaseStorage.instance.ref("/" + widget.id).listAll();
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.path)
            .get(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            final userData = snap.data!.data();
            return Scaffold(
                appBar: backAppBar(widget.name),
                backgroundColor: Color(4279243537),
                body: FutureBuilder<ListResult>(
                  future: futurefiles,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.done) {
                      final files = snap.data!.items;
                      return Column(
                        children: [
                          btnCenter("Send Files to: " + widget.id, Icons.create,
                              () => uploadFile()),
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: ListView.builder(
                                itemCount: files.length,
                                itemBuilder: (context, pos) {
                                  final file = files[pos];
                                  return Padding(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 15),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      color: Color(0xFF2A2A2A),
                                      child: ListTile(
                                        textColor: Colors.white,
                                        trailing: TextButton(
                                          child: Icon(Icons.download),
                                          onPressed: () => loadfile(file),
                                        ),
                                        title: Text(file.name),
                                        subtitle: Text(
                                          file.fullPath,
                                          style:
                                              TextStyle(color: Colors.white38),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ))
                        ],
                      );
                    } else {
                      return LoadingPage();
                    }
                  },
                ));
          } else {
            return LoadingPage();
          }
        });
  }

  void loadfile(Reference file) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userAuth.currentUser!.uid)
        .get()
        .then((value) {
      final userData = value.data();
      final path = File(userData!["path"] + "/" + file.name);
      file.writeToFile(path).then((p0) {
        snackBar(
            "The File ‘" +
                file.name +
                "‘ has been stored to " +
                userData["path"],
            context);
      });
    });
  }

  Future showFiles() async {
    await FilePicker.platform
        .pickFiles(
      type: FileType.any,
      lockParentWindow: true,
      allowMultiple: true,
    )
        .then((value) async {
      try {
        //pattern fürs aufrufen idderDoc
        final storage =
            FirebaseStorage.instanceFor(bucket: "gs://notes-48b92.appspot.com")
                .ref();
        value!.files.forEach((element) {
          storage
              .child(widget.id + "/" + element.name!)
              .putFile(File(element.path!))
              .then((p0) {
            setState(() {
              snackBar("Your File/s has been uploaded", context);
            });
          });
        });
      } on AssertionError catch (e) {
        snackBar(
            "Something went wrong! Files like: .exe, .dll, .bat, .apk and .ipa cant be uploaded, maybe you were trying to upload one of these",
            context);
      }
    });
  }

  void uploadFile() async {
    openAppSettings();
  }
}

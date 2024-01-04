import 'package:flutter/material.dart';
import 'package:remote/auth/auth.dart';
import 'package:remote/pages/request.dart';
import 'package:remote/res/home.dart';
import 'package:remote/res/nav.dart';

AppBar backAppBar(String title) {
  return AppBar(
    scrolledUnderElevation: 0,
    automaticallyImplyLeading: true,
    foregroundColor: Colors.white,
    backgroundColor: Colors.transparent,
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

AppBar homeAppBar(String title, context) {
  friendSystem system = friendSystem();
  return AppBar(
    scrolledUnderElevation: 0,
    actions: [
      TextButton(
        onPressed: () {
          //userAuth.signOut();
          system.showSettings(context);
        },
        child: Icon(
          Icons.settings,
          color: Colors.white,
        ),
      ),
      TextButton(
        onPressed: () {
          //userAuth.signOut();
          system.createResp();
        },
        child: Icon(
          Icons.create_new_folder,
          color: Colors.white,
        ),
      ),
      TextButton(
        onPressed: () {
          //userAuth.signOut();
          nav(context, RequestPage());
        },
        child: Icon(
          Icons.mail,
          color: Colors.white,
        ),
      )
    ],
    backgroundColor: Colors.transparent,
    title: Text(
      title,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}

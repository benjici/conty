import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:remote/auth/auth.dart';
import 'package:remote/firebase_options.dart';
import 'package:remote/pages/register.dart';
import 'package:remote/res/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDaLBM_LtOzMND9X0TPMZh9dSWW-KASpAw",
          authDomain: "notes-48b92.firebaseapp.com",
          databaseURL: "https://notes-48b92-default-rtdb.firebaseio.com",
          projectId: "notes-48b92",
          storageBucket: "notes-48b92.appspot.com",
          messagingSenderId: "473344588416",
          appId: appId(),
          measurementId: "G-9SQVP5JLC7"));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainPage(),
  ));
}

String appId() {
  if (Platform.isMacOS) {
    return "1:473344588416:ios:6a60fbe219fdcbccc60465";
  } else {
    return "1:473344588416:web:05515be9adb70e89c60465";
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return RegisterPage();
          }
        });
  }
}

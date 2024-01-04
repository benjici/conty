import 'package:flutter/material.dart';

Widget btn(String title, IconData ic, VoidCallback action) {
  return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 42, 19, 106),
              borderRadius: BorderRadius.circular(5)),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent),
              onPressed: () {
                action();
              },
              child: Padding(
                padding: EdgeInsets.only(top: 11, bottom: 11),
                child: Row(
                  children: [
                    Icon(
                      ic,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        title,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))));
}

Widget btnCenter(String title, IconData ic, VoidCallback action) {
  return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 42, 19, 106),
              borderRadius: BorderRadius.circular(5)),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent),
              onPressed: () {
                action();
              },
              child: Padding(
                padding: EdgeInsets.only(top: 11, bottom: 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      ic,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        title,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))));
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget inp(TextEditingController con, String title, IconData ic) {
  return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Container(
          decoration: BoxDecoration(
              color: Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: TextField(
              controller: con,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: title,
                  hintStyle: TextStyle(color: Colors.white38),
                  prefixIcon: Icon(
                    ic,
                    color: Colors.white38,
                  )),
            ),
          )));
}

Widget deviceInp(TextEditingController con, String title, IconData ic) {
  return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Container(
          decoration: BoxDecoration(
              color: Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: TextField(
              maxLength: 9,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: con,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  hintText: title,
                  hintStyle: TextStyle(color: Colors.white38),
                  prefixIcon: Icon(
                    ic,
                    color: Colors.white38,
                  )),
            ),
          )));
}

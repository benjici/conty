import 'package:flutter/material.dart';

Future nav(context, page) {
  return Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
    String content, context) {
  final sb = SnackBar(content: Text(content));
  return ScaffoldMessenger.of(context).showSnackBar(sb);
}

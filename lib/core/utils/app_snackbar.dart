import 'package:flutter/material.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/main.dart';

void showSnackBar(String error, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        error,
        style: kTextStyle(12, isBold: true, color: Colors.white),
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ),
  );
}

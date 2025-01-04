import 'package:flutter/material.dart';
import 'package:home_quest/core/utils/textstyle.dart';

void showSnackBar(BuildContext context, String error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        error,
        style: kTextStyle(12, isBold: true),
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ),
  );
  
}

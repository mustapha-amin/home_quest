import 'package:flutter/material.dart';
import 'package:home_quest/core/utils/textstyle.dart';

void showSnackBar(String text, BuildContext context, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: kTextStyle(12, isBold: true, color: Colors.white),
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: const Duration(seconds: 3),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:sizer/sizer.dart';

void showErrorDialog(BuildContext context, String error) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          "Error",
          style: kTextStyle(20),
        ),
        content: SizedBox(
            width: 85.w,
          child: Text(
            error,
            style: kTextStyle(15),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Ok",
              style: kTextStyle(
                16,
                color: Colors.blue,
              ),
            ),
          )
        ],
      );
    },
  );
}

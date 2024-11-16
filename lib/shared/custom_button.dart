import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/textstyle.dart';

class CustomButton extends StatelessWidget {
  String? label;
  VoidCallback? onTap;
  CustomButton({this.label, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.greenAccent,
            Colors.yellow,
          ],
        ),
      ),
      child: Material(
        color: const Color.fromARGB(0, 126, 40, 40),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              label!,
              style: kTextStyle(18),
            ),
          ),
        ),
      ),
    );
  }
}

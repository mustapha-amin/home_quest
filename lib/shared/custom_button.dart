import 'package:flutter/material.dart';
import 'package:home_quest/core/colors.dart';
import 'package:sizer/sizer.dart';

import '../core/utils/textstyle.dart';

class CustomButton extends StatelessWidget {
  String? label;
  VoidCallback? onTap;
  double? width;
  Color? color;
  CustomButton({this.label, this.onTap, this.width, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 100.w,
      height: 50,
      decoration: BoxDecoration(
        color: color ?? AppColors.brown,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: const Color.fromARGB(0, 126, 40, 40),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              label ?? "",
              style: kTextStyle(18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

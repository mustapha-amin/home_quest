import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/textstyle.dart';

class OnboardBtn extends StatelessWidget {
  const OnboardBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
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
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {},
          child: Center(
            child: Text(
              "Get started",
              style: kTextStyle(20),
            ),
          ),
        ),
      ),
    );
  }
}

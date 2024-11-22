import 'package:flutter/material.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/image_path_gen.dart';
import '../../../core/utils/textstyle.dart';

class GoogleBttn extends StatelessWidget {
  const GoogleBttn({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 50,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {},
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              genImagePath("google", ImageType.png),
              width: 35,
            ),
            spaceX(10),
            Text(
              "Continue with Google",
              style: kTextStyle(18),
            )
          ],
        ),
      ),
    );
  }
}

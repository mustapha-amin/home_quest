import 'package:flutter/material.dart';

import '../../../../../core/utils/textstyle.dart';

class PicturesTextHeader extends StatelessWidget {
  const PicturesTextHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "Pictures\n",
        style: kTextStyle(18, isBold: true),
        children: [
          TextSpan(
            text: "Add 5 - 10 pictures\nFirst picture is the cover picture",
            style: kTextStyle(15),
          ),
        ],
      ),
    );
  }
}

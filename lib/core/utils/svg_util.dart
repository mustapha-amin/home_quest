import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

SvgPicture svgImage(String path, bool isEnabled) {
  return SvgPicture.asset(
    path,
    colorFilter: ColorFilter.mode(
        isEnabled ? Colors.black : Colors.grey, BlendMode.srcIn),
    width: 7.w,
  );
}

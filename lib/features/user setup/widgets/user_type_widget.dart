import 'package:flutter/material.dart';
import 'package:home_quest/features/user%20setup/views/user_type.dart';
import 'package:sizer/sizer.dart';

import '../../../core/enums.dart';
import '../../../core/utils/image_path_gen.dart';
import '../../../core/utils/textstyle.dart';
import '../../../shared/spacing.dart';

class UserTypeWidget extends StatelessWidget {
  final VoidCallback onTap;
  final UserType selectedUserType;
  final String name;

  const UserTypeWidget({
    required this.onTap,
    required this.selectedUserType,
    required this.name,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 35.w,
            height: 35.w,
            decoration: BoxDecoration(
              // shape: BoxShape.circle,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey,
              ),
              color: name == selectedUserType.name
                  ? Colors.greenAccent
                  : Colors.transparent,
              image: DecorationImage(
                image: AssetImage(
                  genImagePath(name, ImageType.png),
                ),
              ),
            ),
          ),
        ),
        spaceY(20),
        Text(
          name == UserType.agent.name ? "Agent" : "Renter/Buyer",
          style: kTextStyle(18),
        ),
      ],
    );
  }
}
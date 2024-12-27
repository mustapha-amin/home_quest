import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/colors.dart';
import '../../../../../core/utils/textstyle.dart';
import '../../../../../shared/spacing.dart';

class MappingHintWidget extends StatelessWidget {
  const MappingHintWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedHelpCircle,
            color: AppColors.brown,
            size: 20,
          ),
          spaceX(5),
          Text(
            "Move to select location",
            style: kTextStyle(14),
          ),
        ],
      ),
    );
  }
}

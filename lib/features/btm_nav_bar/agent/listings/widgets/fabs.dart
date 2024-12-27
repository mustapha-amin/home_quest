import 'package:flutter/material.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/colors.dart';

class Fabs extends StatelessWidget {
 final VoidCallback fab1OnPressed;
 final VoidCallback fab2OnPressed;
  const Fabs({required this.fab1OnPressed, required this.fab2OnPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            heroTag: 'btn1',
            onPressed: fab1OnPressed,
            tooltip: 'Select Location',
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedTick01,
              color: AppColors.brown,
              size: 30,
            ),
          ),
        ),
        spaceY(5),
        
      ],
    );
  }
}

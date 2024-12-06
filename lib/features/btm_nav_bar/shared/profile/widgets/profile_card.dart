import 'package:flutter/material.dart';
import 'package:home_quest/core/colors.dart';
import 'package:hugeicons/hugeicons.dart';

class ProfileCard extends StatelessWidget {
  final String text;
  final IconData icon;
  VoidCallback? onTap;
  ProfileCard({required this.text, required this.icon, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: HugeIcon(
        icon: icon,
        color: AppColors.brown,
      ),
      title: Text(text),
      trailing: const HugeIcon(
        icon: HugeIcons.strokeRoundedArrowRight01,
        color: AppColors.brown,
      ),
      onTap: onTap,
    );
  }
}

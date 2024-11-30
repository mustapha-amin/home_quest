import 'package:flutter/material.dart';
import 'package:home_quest/features/btm_nav_bar/shared/profile/widgets/profile_card.dart';
import 'package:hugeicons/hugeicons.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Card.outlined(
            child: Column(
              children: [
                ProfileCard(
                  text: "Reset password",
                  icon: HugeIcons.strokeRoundedResetPassword,
                ),
                ProfileCard(
                  text: "Delete account",
                  icon: HugeIcons.strokeRoundedDelete01,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

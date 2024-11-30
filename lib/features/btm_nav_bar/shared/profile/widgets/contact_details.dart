import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/models/user.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/colors.dart';
import '../../../../../core/providers.dart';

class ContactDetails extends ConsumerWidget {
  final User user;
  const ContactDetails({required this.user, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          leading: const HugeIcon(
              icon: HugeIcons.strokeRoundedCall, color: AppColors.brown),
          title: Text("0${user.phoneNumber}"),
        ),
        ListTile(
          leading: const HugeIcon(
              icon: HugeIcons.strokeRoundedMail01, color: AppColors.brown),
          title: Text(ref.watch(firebaseAuthProvider).currentUser!.email!),
        ),
      ],
    );
  }
}

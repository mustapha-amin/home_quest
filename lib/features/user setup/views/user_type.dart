import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/user%20setup/views/user_setup.dart';
import 'package:home_quest/features/user%20setup/widgets/user_type_widget.dart';
import 'package:home_quest/shared/spacing.dart';

import '../../../core/enums.dart';

final canProceedCtrl = StateProvider<bool>((ref) {
  return false;
});

final userTypeCtr = StateProvider<UserType>((ref) {
  return UserType.none;
});

class UserTypeScreen extends ConsumerStatefulWidget {
  const UserTypeScreen({super.key});

  @override
  ConsumerState<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends ConsumerState<UserTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "What describes you best?",
          style: kTextStyle(23, isBold: true),
        ),
        spaceY(30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            UserTypeWidget(
              selectedUserType: ref.watch(userTypeCtr),
              name: "agent",
              onTap: () {
                if (ref.watch(canProceedCtrl) == false) {
                  ref.read(canProceedCtrl.notifier).state = true;
                }
                if (ref.watch(progressCtrl) == 0) {
                  updateProgressVal(ref, 0.5);
                }
                ref.read(userTypeCtr.notifier).state = UserType.agent;
              },
            ),
            UserTypeWidget(
              selectedUserType: ref.watch(userTypeCtr),
              name: "client",
              onTap: () {
                if (ref.watch(canProceedCtrl) == false) {
                  ref.read(canProceedCtrl.notifier).state = true;
                }
                if (ref.watch(progressCtrl) == 0) {
                  updateProgressVal(ref, 0.5);
                }
                ref.read(userTypeCtr.notifier).state = UserType.client;
              },
            ),
          ],
        ),
      ],
    );
  }
}

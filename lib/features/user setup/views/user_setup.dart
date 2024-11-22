import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions/widget_exts.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/user%20setup/views/user_data_setup.dart';
import 'package:home_quest/features/user%20setup/views/user_type.dart';
import 'package:home_quest/shared/custom_button.dart';
import 'package:sizer/sizer.dart';
import '../../../core/colors.dart';
import '../../../core/enums.dart';
import '../../../shared/spacing.dart';

final progressCtrl = StateProvider<double>((ref) {
  return 0;
});

void updateProgressVal(WidgetRef ref, double value) {
  ref.read(progressCtrl.notifier).state = value;
}

class UserSetup extends ConsumerStatefulWidget {
  const UserSetup({super.key});

  @override
  ConsumerState<UserSetup> createState() => _UserSetupState();
}

class _UserSetupState extends ConsumerState<UserSetup> {
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: isFirst
            ? null
            : Text("Profile Setup", style: kTextStyle(20, isBold: true)),
        centerTitle: true,
        leading: isFirst
            ? const SizedBox()
            : BackButton(
                onPressed: () {
                  updateProgressVal(ref, 0.5);
                  setState(() => isFirst = true);
                },
              ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              spaceY(10),
              Stack(
                alignment: Alignment.center,
                children: [
                  LinearProgressIndicator(
                    value: ref.watch(progressCtrl),
                    color: AppColors.brown,
                  ).padX(10),
                  const ColoredBox(
                    color: Colors.white,
                    child: SizedBox(
                      width: 5,
                      height: 50,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              isFirst ? const UserTypeScreen() : const UserDataSetup()
            ],
          ),
          Positioned(
            bottom: 8,
            child: CustomButton(
              label: isFirst ? "Next" : "Done",
              width: 90.w,
              color: ref.watch(userTypeCtr.notifier).state == UserType.none
                  ? Colors.grey[500]
                  : switch (isFirst) {
                    true => AppColors.brown,
                    _ => AppColors.brown,
                  },
              onTap: () {
                if (ref.watch(userTypeCtr.notifier).state != UserType.none) {
                  isFirst
                      ? {
                          updateProgressVal(ref, 1),
                          setState(() => isFirst = false)
                        }
                      : null;
                }
              },
            ).padX(10),
          )
        ],
      ),
    );
  }
}

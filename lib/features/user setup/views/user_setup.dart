import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions/widget_exts.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/user%20setup/views/user_data_setup.dart';
import 'package:home_quest/features/user%20setup/views/user_type.dart';
import '../../../core/colors.dart';
import '../../../shared/spacing.dart';
import 'package:flutter/services.dart';

final isFirstProvider = StateProvider<bool>((ref) {
  return true;
});

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
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isFirst = ref.watch(isFirstProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(isFirst ? "User type" : "Profile Setup",
            style: kTextStyle(20, isBold: true)),
        centerTitle: true,
        leading: isFirst
            ? const SizedBox()
            : BackButton(
                onPressed: () {
                  updateProgressVal(ref, 0.5);
                  ref.invalidate(isFirstProvider);
                },
              ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
          Expanded(
            child: isFirst ? const UserTypeScreen() : const UserDataSetup(),
          ),
        ],
      ),
    );
  }
}

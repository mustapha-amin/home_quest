import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/features/btm_nav_bar/btm_nav_bar.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/features/user%20setup/views/user_data_setup.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/utils/textstyle.dart';

class HomeUserDataWrapper extends ConsumerWidget {
  const HomeUserDataWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDataExistsProvider).when(data: (user) {
      if (user != null) {
        return const BtmNavBar();
      }
      return const UserDataSetup();
    }, error: (_, __) {
      return Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedWifiDisconnected01,
              color: Colors.red,
              size: 150,
            ),
            Text.rich(
              TextSpan(
                text: "Whoops\n",
                style: kTextStyle(25, isBold: true),
                children: [
                  TextSpan(
                    text:
                        "No internet connection was found\nCheck your internet connection and try again",
                    style: kTextStyle(15),
                  )
                ],
              ),
              textAlign: TextAlign.center,
            ),
            TextButton.icon(
              onPressed: () {
                ref.invalidate(userDataExistsProvider);
              },
              label: Text(
                "Refresh",
                style: kTextStyle(16, color: Colors.blue),
              ),
              icon: const Icon(
                Icons.refresh,
                color: Colors.blue,
              ),
            )
          ],
        ),
      ));
    }, loading: () {
      return const Scaffold();
    });
  }
}

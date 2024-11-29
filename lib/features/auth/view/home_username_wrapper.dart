import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/features/btm_nav_bar/btm_nav_bar.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/features/user%20setup/views/user_setup.dart';

class HomeUserDataWrapper extends ConsumerWidget {
  const HomeUserDataWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.watch(userRemoteDataProvider.notifier).userDataExists(
          context, ref.watch(firebaseAuthProvider).currentUser!.uid),
      builder: (context, snapshot) {
        return switch (snapshot.data) {
          true => const BtmNavBar(),
          _ => const UserSetup(),
        };
      },
    );
  }
}

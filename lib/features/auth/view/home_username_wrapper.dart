import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/features/btm_nav_bar/btm_nav_bar.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/features/user%20setup/views/user_data_setup.dart';
import 'package:home_quest/shared/error_screen.dart';

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
      return ErrorScreen(providerToRefresh: clientDataStreamProvider);
    }, loading: () {
      return const Scaffold();
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/features/btm_nav_bar/client/btm_nav_barC.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/features/user%20setup/views/user_data_setup.dart';
import 'package:home_quest/features/user%20setup/views/user_setup.dart';
import 'package:home_quest/models/agent.dart';
import 'package:home_quest/models/client.dart';
import 'package:home_quest/shared/error_screen.dart';
import 'package:home_quest/shared/loading_screen.dart';

import '../../btm_nav_bar/agent/btm_nav_barA.dart';

class HomeUserDataWrapper extends ConsumerWidget {
  const HomeUserDataWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDataExistsProvider).when(
      data: (userExists) {
        if (userExists!) {
          return ref.watch(userDataStreamProvider).when(
                data: (user) {
                  if (ref.read(hiveProvider).isEmpty) {
                    ref
                        .read(userCacheNotifierProvider.notifier)
                        .saveData(user!);
                  }
                  return switch (user.runtimeType) {
                    AgentModel _ => const BtmNavBarA(),
                    _ => const BtmNavBarC(),
                  };
                },
                error: (_, __) => ErrorScreen(
                  providerToRefresh: userDataStreamProvider,
                ),
                loading: () => const LoadingScreen(),
              );
        } else {
          return const UserSetup();
        }
      },
      error: (_, __) {
        return ErrorScreen(providerToRefresh: userDataStreamProvider);
      },
      loading: () {
        return const LoadingScreen();
      },
    );
  }
}

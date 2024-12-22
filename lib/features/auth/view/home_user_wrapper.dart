import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/features/btm_nav_bar/client/btm_nav_barC.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/features/user%20setup/views/user_setup.dart';
import 'package:home_quest/models/agent.dart';
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
                        .refreshFromServer();
                  }
                  if (user.runtimeType == AgentModel) {
                    return const BtmNavBarA();
                  } else {
                    return const BtmNavBarC();
                  }
                },
                error: (e, stk) {
                  log(e.toString());
                  log(stk.toString());
                  return GestureDetector(
                    onTap: () {
                      log(ref.read(hiveProvider).isEmpty.toString());
                    },
                    child: ErrorScreen(
                      errorText: e.toString(),
                      onRefresh: () => ref.invalidate(userDataStreamProvider),
                    ),
                  );
                },
                loading: () => const LoadingScreen(),
              );
        } else {
          return const UserSetup();
        }
      },
      error: (e, __) {
        return ErrorScreen(
          errorText: e.toString(),
          onRefresh: () => ref.invalidate(userDataExistsProvider),
        );
      },
      loading: () {
        return const LoadingScreen();
      },
    );
  }
}

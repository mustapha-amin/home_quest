import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/features/btm_nav_bar/client/btm_nav_barC.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/widgets/listing_widget.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/features/user%20setup/views/user_setup.dart';
import 'package:home_quest/models/agent.dart';
import 'package:home_quest/models/property_listing.dart';
import 'package:home_quest/shared/error_screen.dart';
import 'package:home_quest/shared/loading_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/enums.dart';
import '../../btm_nav_bar/agent/btm_nav_barA.dart';

class HomeUserDataWrapper extends ConsumerWidget {
  const HomeUserDataWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDataExistsCtrl).when(
      data: (userExists) {
        log(userExists.toString() + " from home wrapper");
        if (userExists!) {
          return ref.watch(userDataStreamProvider).when(
            data: (user) {
              log(user.runtimeType.toString());
              if (user.runtimeType == AgentModel) {
                return const BtmNavBarA();
              } else {
                return const BtmNavBarC();
              }
            },
            error: (e, stk) {
              log(e.toString());
              log(stk.toString());
              return ErrorScreen(
                errorText: e.toString() + stk.toString(),
                onRefresh: () => ref.refresh(userDataStreamProvider.future),
              );
            },
            loading: () {
              return const LoadingScreen();
            },
          );
        } else {
          return const UserSetup();
        }
      },
      error: (e, stk) {
        return ErrorScreen(
          errorText: e.toString(),
          onRefresh: () => ref.invalidate(userDataExistsCtrl),
        );
      },
      loading: () {
        return const LoadingScreen();
      },
    );
  }
}

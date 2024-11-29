import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions/navigations.dart';
import 'package:home_quest/core/utils/errordialog.dart';
import 'package:home_quest/features/btm_nav_bar/btm_nav_bar.dart';
import 'package:home_quest/features/user%20setup/repository/user_data_repository.dart';
import 'package:home_quest/models/agent.dart';
import 'package:home_quest/models/client.dart';

import '../../../core/providers.dart';
import '../../../core/typedefs.dart';

final clientDataProvider =
    NotifierProvider<ClientDataNotifier, ClientModel?>(ClientDataNotifier.new);

final agentDataProvider =
    NotifierProvider<AgentDataNotifier, AgentModel?>(AgentDataNotifier.new);

final userRemoteDataProvider =
    StateNotifierProvider<UserRemoteDataNotifier, bool>((ref) {
  return UserRemoteDataNotifier(ref.watch(userDataRepoProvider), ref);
});

class ClientDataNotifier extends Notifier<ClientModel?> {
  @override
  ClientModel? build() {
    return ClientModel.defaultInstance();
  }

  void updateClientData(ClientModel clientModel) {
    state = clientModel;
  }
}

class AgentDataNotifier extends Notifier<AgentModel?> {
  @override
  AgentModel? build() {
    return AgentModel.defaultInstance();
  }

  void updateAgentData(AgentModel agentModel) {
    state = agentModel;
  }
}

class UserRemoteDataNotifier extends StateNotifier<bool> {
  final UserDataRepository userDataRepo;
  final Ref ref;
  UserRemoteDataNotifier(this.userDataRepo, this.ref) : super(false);

  FutureVoid _handleOperation(FutureVoid Function() operation, Ref ref) async {
    state = true;
    ref.read(isLoading.notifier).state = state;
    await operation();
    state = false;
    ref.invalidate(isLoading);
  }

  FutureVoid saveClientData(
      BuildContext context, ClientModel? client, File image) async {
    try {
     await _handleOperation(() async {
        await userDataRepo.saveClientData(client!, image);
        context.replace(const BtmNavBar());
      }, ref);
    } catch (e) {
      ref.invalidate(isLoading);
      showErrorDialog(context, e.toString());
    }
  }

  FutureVoid saveAgentData(
      BuildContext context, AgentModel? agent, File image) async {
    try {
     await _handleOperation(() async {
        await userDataRepo.saveAgentData(agent!, image);
        context.replace(const BtmNavBar());
      }, ref);
    } catch (e) {
      ref.invalidate(isLoading);
      showErrorDialog(context, e.toString());
    }
  }

  Future<bool?> userDataExists(BuildContext context, String? uid) async {
    try {
      return await userDataRepo.userDataExists(uid);
    } catch (e) {
      showErrorDialog(context, e.toString());
      return null;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/shared/error_screen.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ref.watch(clientDataStreamProvider).when(
        data: (client) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 5,
                    ),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(client!.profilePicture),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Text(client.name),
              Text(ref.watch(firebaseAuthProvider).currentUser!.email!),
              Text("0${client.phoneNumber}"),
            ],
          );
        },
        error: (_, __) {
          return ErrorScreen(providerToRefresh: clientDataStreamProvider);
        },
        loading: () {
          return Center(
            child: SpinKitWaveSpinner(
              size: 80,
              color: Color.fromARGB(255, 70, 41, 0),
            ),
          );
        },
      ),
    );
  }
}

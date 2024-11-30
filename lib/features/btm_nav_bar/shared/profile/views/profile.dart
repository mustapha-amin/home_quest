import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_quest/core/extensions/widget_exts.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/btm_nav_bar/shared/profile/widgets/contact_details.dart';
import 'package:home_quest/features/btm_nav_bar/shared/profile/widgets/profile_card.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/models/client.dart';
import 'package:home_quest/shared/error_screen.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(userDataStreamProvider).when(
      data: (user) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[200]!,
                          width: 5,
                        ),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(user!.profilePicture),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: kTextStyle(20, isBold: true),
                        ),
                        Text(
                          user is ClientModel ? "Client" : "Agent",
                          style: kTextStyle(16),
                        ),
                      ],
                    ),
                    SizedBox(width: 20.w)
                  ],
                ),
                ContactDetails(user: user),
                Card.outlined(
                  child: Column(
                    children: [
                      ProfileCard(
                        text: "Edit profile",
                        icon: HugeIcons.strokeRoundedEdit01,
                      ),
                      ProfileCard(
                        text: "Settings",
                        icon: HugeIcons.strokeRoundedSettings01,
                      ),
                      ProfileCard(
                        text: "Help",
                        icon: HugeIcons.strokeRoundedHelpCircle,
                      ),
                      ProfileCard(
                        text: "Log out",
                        icon: HugeIcons.strokeRoundedLogout02,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            OutlinedButton.icon(
              onPressed: () {},
              label: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Delete account",
                    style: kTextStyle(18, color: Colors.red),
                  ),
                  spaceX(5),
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedDelete01,
                    color: Colors.red,
                    size: 20,
                  )
                ],
              ),
            )
          ],
        ).padX(12);
      },
      error: (_, __) {
        return ErrorScreen(providerToRefresh: userDataStreamProvider);
      },
      loading: () {
        return const Center(
          child: SpinKitWaveSpinner(
            size: 80,
            color: Color.fromARGB(255, 70, 41, 0),
          ),
        );
      },
    );
  }
}

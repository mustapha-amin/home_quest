import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions/navigations.dart';
import 'package:home_quest/core/extensions/widget_exts.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/auth/controller/auth_controller.dart';
import 'package:home_quest/features/auth/view/auth_screen.dart';
import 'package:home_quest/features/btm_nav_bar/shared/profile/views/account.dart';
import 'package:home_quest/features/btm_nav_bar/shared/profile/views/edit_profile.dart';
import 'package:home_quest/features/btm_nav_bar/shared/profile/widgets/contact_details.dart';
import 'package:home_quest/features/btm_nav_bar/shared/profile/widgets/profile_card.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/main.dart';
import 'package:home_quest/models/client.dart';
import 'package:home_quest/services/user_data_cache.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sizer/sizer.dart';

import '../../../../../shared/error_screen.dart';
import '../../../../../shared/loading_screen.dart';
import '../../../../../shared/user_avatar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(userDataStreamProvider).when(
          data: (data) {
            final user = data;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Hero(
                      tag: 'avatar',
                      flightShuttleBuilder: (context, _, flightDirection,
                          fromHeroContext, toHeroCOntext) {
                        return Material(
                          color: Colors.transparent,
                          child: switch (flightDirection) {
                            HeroFlightDirection.push => toHeroCOntext.widget,
                            HeroFlightDirection.pop => fromHeroContext.widget
                          },
                        );
                      },
                      child: UserAvatar(
                        url: user!.profilePicture,
                        width: 30.w,
                        height: 30.w,
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
                        onTap: () => context.push(const EditProfile()),
                      ),
                      ProfileCard(
                        text: "Settings",
                        icon: HugeIcons.strokeRoundedSettings01,
                      ),
                      ProfileCard(
                        text: "Help",
                        icon: HugeIcons.strokeRoundedHelpCircle,
                        onTap: () {
                          log(ref
                              .watch(userDataCacheProvider)
                              .getUserData()
                              .runtimeType
                              .toString());
                        },
                      ),
                      ProfileCard(
                        text: "Account",
                        icon: HugeIcons.strokeRoundedUserAccount,
                        onTap: () => context.push(const Account()),
                      ),
                      ProfileCard(
                        text: "Log out",
                        icon: HugeIcons.strokeRoundedLogout02,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "Log Out",
                                  style: kTextStyle(18, isBold: true),
                                ),
                                content: SizedBox(
                                  width: 85.w,
                                  child: Text(
                                    "Do you want to log out?",
                                    style: kTextStyle(16),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await ref
                                          .read(authControllerProvider.notifier)
                                          .signOut(context, ref,
                                              user is ClientModel);
                                      await ref
                                          .read(userCacheNotifierProvider
                                              .notifier)
                                          .deleteData();
                                    },
                                    child: Text(
                                      "Yes",
                                      style: kTextStyle(15, color: Colors.red),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                      "No",
                                      style: kTextStyle(15),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ).padX(12);
          },
          error: (e, stk) {
            log(e.toString());
            log(stk.toString());
            return ErrorScreen(
              errorText: e.toString(),
              onRefresh: () => ref.invalidate(userDataStreamProvider),
            );
          },
          loading: () => const LoadingScreen(),
        );
  }
}

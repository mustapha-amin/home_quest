import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions/navigations.dart';
import 'package:home_quest/features/btm_nav_bar/agent/appointments/views/appointments.dart';
import 'package:home_quest/features/btm_nav_bar/agent/dashboard/view/dashboard.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/views/add_listings.dart';
import 'package:home_quest/features/btm_nav_bar/shared/profile/views/profile.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sizer/sizer.dart';

import '../../../core/providers.dart';
import '../../../core/utils/image_path.dart';
import '../../../core/utils/svg_util.dart';
import '../../../shared/user_avatar.dart';
import 'listings/views/listings.dart';

final currentAgentScreenProvider = StateProvider<int>((ref) {
  return 0;
});

void navigateTo(WidgetRef ref, int screen) {
  if (screen != ref.watch(currentAgentScreenProvider)) {
    ref.read(currentAgentScreenProvider.notifier).state = screen;
  }
}

class BtmNavBarA extends ConsumerStatefulWidget {
  const BtmNavBarA({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BtmNavBarAState();
}

class _BtmNavBarAState extends ConsumerState<BtmNavBarA> {
  List<Widget> screens = const [
    AgentDashboard(),
    Appointments(),
    Listings(),
    ProfileScreen(),
  ];

  List<String> btmNavBarIcons = [
    ImagePaths.house_svg,
    ImagePaths.listing,
    ImagePaths.task,
  ];

  List<String> btmNavBarIconsFilled = [
    ImagePaths.house_filled_svg,
    ImagePaths.listing_filled,
    ImagePaths.task_filled,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: screens[ref.watch(currentAgentScreenProvider)],
      floatingActionButton: ref.watch(currentAgentScreenProvider) == 1 ||
              ref.watch(currentAgentScreenProvider) == 2
          ? FloatingActionButton(
              elevation: 3,
              onPressed: () {
                if (ref.watch(currentAgentScreenProvider) == 1) {
                  context.push(const AddListings());
                } else {
                  context.push(const Appointments());
                }
              },
              child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedAdd01, color: Colors.black),
            )
          : const SizedBox(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: Colors.black,
        enableFeedback: false,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: ref.watch(currentAgentScreenProvider),
        onTap: (value) {
          navigateTo(ref, value);
        },
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedDashboardSquare01,
                color: ref.watch(currentAgentScreenProvider) == 0
                    ? Colors.black
                    : Colors.grey,
                size: 25,
              ),
            ),
            label: "Dashboard",
          ),
          ...screens
              .where((screen) =>
                  screens.indexOf(screen) < 3 && screens.indexOf(screen) > 0)
              .map((screen) {
            return BottomNavigationBarItem(
              icon: screens.indexOf(screen) ==
                      ref.watch(currentAgentScreenProvider)
                  ? svgImage(
                      btmNavBarIconsFilled[screens.indexOf(screen)], true)
                  : svgImage(btmNavBarIcons[screens.indexOf(screen)], false),
              label: switch (screens.indexOf(screen)) {
                1 => "Listings",
                _ => "Appointments",
              },
            );
          }),
          BottomNavigationBarItem(
            label: "Profile",
            icon: UserAvatar(
              url: ref.watch(userCacheNotifierProvider)!.profilePicture,
              height: 7.w,
              width: 7.w,
            ),
          )
        ],
      ),
    );
  }
}

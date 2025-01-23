import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions.dart';

import 'package:home_quest/features/btm_nav_bar/agent/dashboard/view/dashboard.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/views/add_listings.dart';
import 'package:home_quest/features/btm_nav_bar/shared/profile/views/profile.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/image_path.dart';
import '../../../core/utils/svg_util.dart';
import '../../../core/utils/textstyle.dart';
import '../../../shared/spacing.dart';
import '../../../shared/user_avatar.dart';
import 'listings/views/listings.dart';

final currentAgentScreenProvider = StateProvider.autoDispose<int>((ref) {
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
  List<Widget> screensA = const [
    AgentDashboard(),
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
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("HomeQuest", style: kTextStyle(30)),
              spaceX(4),
              Image.asset(ImagePaths.homeLogo, height: 25),
            ],
          ).padX(10),
        ]),
      ),
      body: screensA[ref.watch(currentAgentScreenProvider)],
      floatingActionButton: ref.watch(currentAgentScreenProvider) == 1
          ? FloatingActionButton(
              elevation: 3,
              onPressed: () {
                context.push(AddListings());
              },
              child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedAdd01, color: Colors.black),
            )
          : const SizedBox(),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        height: 6.5.h,
        selectedIndex: ref.watch(currentAgentScreenProvider),
        onDestinationSelected: (value) {
          navigateTo(ref, value);
        },
        destinations: [
          NavigationDestination(
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
          NavigationDestination(
              icon: ref.watch(currentAgentScreenProvider) == 1
                  ? svgImage(btmNavBarIconsFilled[1], true)
                  : svgImage(btmNavBarIcons[1], false),
              label: "My Listings"),
          NavigationDestination(
            label: "Profile",
            icon: UserAvatar(
              url: ref
                  .watch(userDataStreamProvider)
                  .asData!
                  .value!
                  .profilePicture,
              height: 7.w,
              width: 7.w,
            ),
          )
        ],
      ),
    );
  }
}

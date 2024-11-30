import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/features/btm_nav_bar/agent/appointments/views/appointments.dart';
import 'package:home_quest/features/btm_nav_bar/agent/dashboard/view/dashboard.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/views/listings.dart';
import 'package:home_quest/features/btm_nav_bar/shared/profile/views/profile.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/image_path.dart';
import '../../../core/utils/svg_util.dart';
import '../../user setup/controller/user_data_controller.dart';

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
          ...screens
              .where((screen) => screens.indexOf(screen) < 3)
              .map((screen) {
            return BottomNavigationBarItem(
              icon: screens.indexOf(screen) < 3
                  ? screens.indexOf(screen) == ref.watch(currentAgentScreenProvider)
                      ? svgImage(
                          btmNavBarIconsFilled[screens.indexOf(screen)], true)
                      : svgImage(btmNavBarIcons[screens.indexOf(screen)], false)
                  : const SizedBox(),
              label: switch (screens.indexOf(screen)) {
                0 => "Dashboard",
                1 => "Listings",
                _ => "Appointments",
              },
            );
          }),
          BottomNavigationBarItem(
            label: "Profile",
            icon: ref.watch(userDataStreamProvider).when(
                  data: (agent) => Container(
                    width: 7.w,
                    height: 7.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ref.watch(currentAgentScreenProvider) == 3
                            ? Colors.black
                            : Colors.grey,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(agent!.profilePicture),
                      ),
                    ),
                  ),
                  error: (_, __) => const HugeIcon(
                      icon: HugeIcons.strokeRoundedRssError, color: Colors.red),
                  loading: () => const HugeIcon(
                    icon: HugeIcons.strokeRoundedProfile,
                    color: Colors.black,
                  ),
                ),
          )
        ],
      ),
    );
  }
}

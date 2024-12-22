import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/core/utils/image_path.dart';
import 'package:home_quest/core/utils/svg_util.dart';
import 'package:home_quest/features/btm_nav_bar/client/favorites/favorites.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/home.dart';
import 'package:home_quest/features/btm_nav_bar/client/search/search.dart';
import 'package:home_quest/features/btm_nav_bar/shared/profile/views/profile.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/user_avatar.dart';

final currentScreenProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

void navigateTo(WidgetRef ref, int screen) {
  if (screen != ref.watch(currentScreenProvider)) {
    ref.read(currentScreenProvider.notifier).state = screen;
  }
}

class BtmNavBarC extends ConsumerStatefulWidget {
  const BtmNavBarC({super.key});

  @override
  ConsumerState<BtmNavBarC> createState() => _BtmNavBarState();
}

class _BtmNavBarState extends ConsumerState<BtmNavBarC> {
  List<Widget> screens = const [
    HomeScreen(),
    SearchScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  List<String> btmNavBarIcons = [
    ImagePaths.house_svg,
    ImagePaths.heart,
    ImagePaths.task,
  ];

  List<String> btmNavBarIconsFilled = [
    ImagePaths.house_filled_svg,
    ImagePaths.heart_filled,
    ImagePaths.task_filled,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: screens[ref.watch(currentScreenProvider)],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: ref.watch(currentScreenProvider),
        onTap: (value) {
          navigateTo(ref, value);
        },
        items: [
          BottomNavigationBarItem(
            icon: ref.watch(currentScreenProvider) == 0
                ? svgImage(btmNavBarIconsFilled[0], true)
                : svgImage(btmNavBarIcons[0], false),
            label: "Home",
          ),
           BottomNavigationBarItem(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedSearch01, color: ref.watch(currentScreenProvider) == 1 ? Colors.black : Colors.grey),
            label: "Search",
          ),
           BottomNavigationBarItem(
            icon: ref.watch(currentScreenProvider) == 2
                ? svgImage(btmNavBarIconsFilled[1], true)
                : svgImage(btmNavBarIcons[1], false),
            label: "Favorite",
          ),
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

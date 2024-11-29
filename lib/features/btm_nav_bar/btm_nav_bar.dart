import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/utils/image_path.dart';
import 'package:home_quest/core/utils/svg_util.dart';
import 'package:home_quest/features/btm_nav_bar/nav_bar_items/favorites/favorites.dart';
import 'package:home_quest/features/btm_nav_bar/nav_bar_items/home/home.dart';
import 'package:home_quest/features/btm_nav_bar/nav_bar_items/profile/profile.dart';
import 'package:home_quest/features/btm_nav_bar/nav_bar_items/search/search.dart';

final currentScreenProvider = StateProvider<int>((ref) {
  return 0;
});

void navigateTo(WidgetRef ref, int screen) {
  if (screen != ref.watch(currentScreenProvider)) {
    ref.read(currentScreenProvider.notifier).state = screen;
  }
}

class BtmNavBar extends ConsumerStatefulWidget {
  const BtmNavBar({super.key});

  @override
  ConsumerState<BtmNavBar> createState() => _BtmNavBarState();
}

class _BtmNavBarState extends ConsumerState<BtmNavBar> {
  List<Widget> screens = const [
    HomeScreen(),
    SearchScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  List<String> btmNavBarIcons = [
    ImagePaths.house_svg,
    ImagePaths.search,
    ImagePaths.heart,
  ];

  List<String> btmNavBarIconsFilled = [
    ImagePaths.house_filled_svg,
    ImagePaths.search,
    ImagePaths.heart_filled,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[ref.watch(currentScreenProvider)],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        enableFeedback: false,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: ref.watch(currentScreenProvider),
        onTap: (value) {
          navigateTo(ref, value);
        },
        items: [
          ...screens.map(
            (screen) => BottomNavigationBarItem(
              icon: screens.indexOf(screen) < 3
                  ? svgImage(btmNavBarIcons[screens.indexOf(screen)], false)
                  : Icon(Icons.person),
              label: switch (screens.indexOf(screen)) {
                0 => "Home",
                1 => "Search",
                2 => "Favorites",
                _ => "Profile"
              },
              activeIcon: screens.indexOf(screen) < 3
                  ? svgImage(
                      btmNavBarIconsFilled[screens.indexOf(screen)], true)
                  : Icon(Icons.person),
            ),
          )
        ],
      ),
    );
  }
}

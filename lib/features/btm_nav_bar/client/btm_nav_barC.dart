import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/colors.dart';
import 'package:home_quest/core/enums.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/utils/image_path.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/btm_nav_bar/client/bookmarks/bookmarks.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/views/home.dart';
import 'package:home_quest/features/btm_nav_bar/client/search/controller/search_filter_ctrl.dart';
import 'package:home_quest/features/btm_nav_bar/client/search/search.dart';
import 'package:home_quest/features/btm_nav_bar/client/search/widgets/modal_sheet.dart';
import 'package:home_quest/features/btm_nav_bar/shared/profile/views/profile.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
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

class _BtmNavBarState extends ConsumerState<BtmNavBarC>
    with SingleTickerProviderStateMixin {
  late AnimationController? _controller;
  ListingType listingType = ListingType.rent;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

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
        leading: ref.watch(currentScreenProvider) == 1
            ? switch (ref.watch(searchFilterProvider).searching) {
                true => BackButton(
                    onPressed: () {
                      ref.invalidate(searchFilterProvider);
                      showModalBottomSheet(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35),
                          ),
                        ),
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 95.h,
                            child: const SearchBottomSheet(),
                          );
                        },
                      );
                    },
                  ),
                _ => null
              }
            : null,
        forceMaterialTransparency: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!ref.watch(searchFilterProvider).searching ||
                    ref.watch(currentScreenProvider) != 1) ...{
                  Text("HomeQuest", style: kTextStyle(30)),
                  spaceX(4),
                  Image.asset(ImagePaths.homeLogo, height: 25),
                },
              ],
            ).padX(10),
            if (ref.watch(currentScreenProvider) == 1)
              IconButton(
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedSearch01,
                  color: AppColors.brown,
                  size: 30,
                ),
                onPressed: () {
                  ref.invalidate(searchFilterProvider);
                  showModalBottomSheet(
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                    ),
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height: 95.h,
                        child: const SearchBottomSheet(),
                      );
                    },
                  );
                },
              )
          ],
        ),
      ),
      body: IndexedStack(
        index: ref.watch(currentScreenProvider),
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        height: 6.5.h,
        selectedIndex: ref.watch(currentScreenProvider),
        onDestinationSelected: (value) {
          if (value == 1) {
            ref.invalidate(searchFilterProvider);
            showModalBottomSheet(
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              context: context,
              builder: (context) {
                return SizedBox(
                  height: 95.h,
                  child: const SearchBottomSheet(),
                );
              },
            );
          }
          navigateTo(ref, value);
        },
        destinations: [
          NavigationDestination(
            icon: Icon(
              ref.watch(currentScreenProvider) == 0
                  ? Iconsax.home
                  : Iconsax.home_1_copy,
              size: 26,
              color: ref.watch(currentScreenProvider) == 0
                  ? Colors.black
                  : Colors.grey,
            ),
            label: "Home",
          ),
          NavigationDestination(
            icon: HugeIcon(
                icon: HugeIcons.strokeRoundedSearch01,
                color: ref.watch(currentScreenProvider) == 1
                    ? Colors.black
                    : Colors.grey),
            label: "Search",
          ),
          NavigationDestination(
            icon: ref.watch(currentScreenProvider) == 2
                ? const Icon(
                    Iconsax.bookmark,
                    size: 26,
                  )
                : const Icon(
                    Iconsax.bookmark_copy,
                    size: 26,
                    color: Colors.grey,
                  ),
            label: "Bookmarks",
          ),
          NavigationDestination(
            label: "Profile",
            icon: UserAvatar(
              url: ref.watch(userDataStreamProvider).value!.profilePicture,
              height: 7.w,
              width: 7.w,
            ),
          )
        ],
      ),
    );
  }
}

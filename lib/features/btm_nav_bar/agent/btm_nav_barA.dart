import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/features/btm_nav_bar/agent/appointments/views/appointments.dart';
import 'package:home_quest/features/btm_nav_bar/agent/dashboard/view/dashboard.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/views/listings.dart';
import 'package:home_quest/features/btm_nav_bar/shared/profile/views/profile.dart';

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
          items: [],
        ));
  }
}

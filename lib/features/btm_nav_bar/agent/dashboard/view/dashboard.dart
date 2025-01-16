import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/features/btm_nav_bar/agent/dashboard/widgets/agent_stat_widget.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/controller/property_listing_ctrl.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/models/agent.dart';
import 'package:home_quest/models/agent_stat.dart';
import 'package:home_quest/shared/loading_indicator.dart';
import 'package:hugeicons/hugeicons.dart';

class AgentDashboard extends ConsumerWidget {
  const AgentDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(fetchListingsByAgentIDProvider(
            ref.watch(firebaseAuthProvider).currentUser!.uid))
        .when(
      data: (listings) {
        return GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          children: [
            AgentStatWidget(
                agentStat: AgentStat(
              iconData: HugeIcons.strokeRoundedPropertyView,
              title: "Listings",
              count: listings.length,
            )),
            AgentStatWidget(
                agentStat: AgentStat(
              iconData: HugeIcons.strokeRoundedPropertyView,
              title: "Reviews",
              count: (ref.watch(userDataStreamProvider).value as AgentModel)
                  .reviews
                  .length,
            )),
            AgentStatWidget(
                agentStat: AgentStat(
              iconData: Icons.star,
              title: "Ratings",
              count: (ref.watch(userDataStreamProvider).value as AgentModel)
                      .reviews
                      .map((review) => review.rating)
                      .fold(0, (prev, next) => prev + next) /
                  (ref.watch(userDataStreamProvider).value as AgentModel)
                      .reviews
                      .map((review) => review.rating)
                      .length,
            )),
            AgentStatWidget(
                agentStat: AgentStat(
              iconData: HugeIcons.strokeRoundedPropertyView,
              title: "Listings",
              count: listings.length,
            )),
          ],
        );
      },
      error: (e, stk) {
        return Text("An error occured");
      },
      loading: () {
        return LoadingIndicator();
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/features/btm_nav_bar/agent/dashboard/widgets/agent_stat_widget.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/controller/property_listing_ctrl.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/models/agent.dart';
import 'package:home_quest/models/agent_stat.dart';
import 'package:home_quest/shared/loading_indicator.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/utils/textstyle.dart';
import '../../../../../shared/spacing.dart';

class AgentDashboard extends ConsumerWidget {
  const AgentDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(fetchListingsByAgentIDProvider(
            ref.watch(firebaseAuthProvider).currentUser!.uid))
        .when(
      data: (listings) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 30.h,
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.5,
                  crossAxisCount: 2,
                ),
                children: [
                  AgentStatWidget(
                      agentStat: AgentStat(
                    iconData: Icons.apartment,
                    title: "Listings",
                    count: listings.length,
                  )).animate().fadeIn(delay: const Duration(milliseconds: 70)),
                  AgentStatWidget(
                      agentStat: AgentStat(
                    iconData: HugeIcons.strokeRoundedComment01,
                    title: "Reviews",
                    count:
                        (ref.watch(userDataStreamProvider).value as AgentModel)
                            .reviews
                            .length,
                  )).animate().fadeIn(delay: const Duration(milliseconds: 90)),
                  AgentStatWidget(
                      agentStat: AgentStat(
                    iconData: Icons.star,
                    title: "Ratings",
                    count:
                        (ref.watch(userDataStreamProvider).value as AgentModel)
                                .reviews
                                .isNotEmpty
                            ? (ref.watch(userDataStreamProvider).value
                                        as AgentModel)
                                    .reviews
                                    .map((review) => review.rating)
                                    .fold(0, (prev, next) => prev + next) /
                                (ref.watch(userDataStreamProvider).value
                                        as AgentModel)
                                    .reviews
                                    .map((review) => review.rating)
                                    .length
                            : 0,
                  )).animate().fadeIn(delay: const Duration(milliseconds: 110)),
                  AgentStatWidget(
                      agentStat: AgentStat(
                    iconData: HugeIcons.strokeRoundedPropertyView,
                    title: "Listings",
                    count: listings.length,
                  )).animate().fadeIn(delay: const Duration(milliseconds: 130)),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "Clients' Reviews (${(ref.watch(userDataStreamProvider).value as AgentModel).reviews.length})",
                  style: kTextStyle(28, isBold: true),
                ),
              ],
            ).padAll(8),
            SingleChildScrollView(
              child: Card.outlined(
                child: Column(
                  children: [
                    ...(ref.watch(userDataStreamProvider).value as AgentModel)
                        .reviews
                        .map(
                          (review) => ListTile(
                            title: ref
                                .watch(userDataStreamIDProvider(review.userID))
                                .when(
                              data: (user) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: 3,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        user!.profilePicture,
                                      ),
                                    ),
                                    Text(
                                      user.name,
                                      style: kTextStyle(18, isBold: true),
                                    ),
                                  ],
                                );
                              },
                              error: (e, stk) {
                                return const Text("Error fetching details");
                              },
                              loading: () {
                                return const Text(".......");
                              },
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                spaceY(10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    for (int i = 0; i < 5; i++)
                                      Icon(
                                        Icons.star,
                                        color: i + 1 <= review.rating
                                            ? Colors.amber
                                            : Colors.grey,
                                        size: 14,
                                      ),
                                  ],
                                ),
                                Text(
                                  review.text,
                                  style: kTextStyle(15),
                                ),
                              ],
                            ),
                          ),
                        )
                  ],
                ),
              ),
            )
          ],
        ).padX(5);
      },
      error: (e, stk) {
        return const Text("An error occured");
      },
      loading: () {
        return const LoadingIndicator();
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/controller/property_listing_ctrl.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/widgets/listing_widget.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/models/agent.dart';
import 'package:home_quest/shared/loading_indicator.dart';
import 'package:home_quest/shared/spacing.dart';

class AgentDetailsTabBar extends ConsumerWidget {
  final String agentID;
  const AgentDetailsTabBar({
    super.key,
    required this.agentID,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TabBarView(
      children: [
        ref.watch(fetchListingsByAgentIDProvider(agentID)).when(
          data: (listings) {
            return ListView.builder(
              itemCount: listings.length,
              itemBuilder: (context, index) {
                return ListingWidget(
                  propertyListing: listings[index],
                  isViewDetails: true,
                );
              },
            );
          },
          error: (e, stk) {
            return const Center(
              child: Text('Error fetching listings'),
            );
          },
          loading: () {
            return const LoadingIndicator();
          },
        ),
        Column(
          children: [
            ref.watch(userDataStreamIDProvider(agentID)).when(data: (user) {
              AgentModel agent = user as AgentModel;
              return Expanded(
                child: agent.reviews.isEmpty
                    ? const Center(
                        child: Text("No reviews yet"),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            ...user.reviews.map(
                              (review) => ListTile(
                                title: ref
                                    .watch(
                                        userDataStreamIDProvider(review.userID))
                                    .when(
                                  data: (user) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
              );
            }, error: (_, __) {
              return Text("An error occured");
            }, loading: () {
              return const LoadingIndicator();
            })
          ],
        )
      ],
    );
  }
}

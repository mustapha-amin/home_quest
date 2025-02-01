import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/controller/property_listing_ctrl.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/models/agent.dart';
import 'package:home_quest/shared/loading_indicator.dart';

import '../widgets/agent_listing.dart';

class Listings extends ConsumerWidget {
  const Listings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref
          .watch(fetchListingsByAgentIDProvider(
              ref.watch(firebaseAuthProvider).currentUser!.uid))
          .when(
            data: (listings) {
              return listings.isEmpty
                  ? Center(
                      child: Text(
                        "No listings yet",
                        style: kTextStyle(25),
                      ),
                    )
                  : ref
                      .watch(userDataStreamIDProvider(listings[0].agentID))
                      .when(data: (user) {
                      AgentModel agent = user as AgentModel;
                      return ListView.separated(
                        itemCount: listings.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => log(listings[index].id),
                            child: AgentListing(
                              listing: listings[index],
                              agentModel: agent,
                            ).padX(10).padY(8),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.grey,
                          height: 1,
                        ),
                      );
                    }, error: (e, stk) {
                      return Text("An error occured");
                    }, loading: () {
                      return LoadingIndicator();
                    },);
            },
            loading: () => const Center(
              child: LoadingIndicator(),
            ),
            error: (error, stackTrace) {
              log(error.toString());
              log(stackTrace.toString());
              return Center(
                child: Text('Error: $error $stackTrace'),
              );
            },
          ),
    );
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/enums.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/controller/property_listing_ctrl.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/models/agent.dart';
import 'package:home_quest/models/property_listing.dart';
import 'package:home_quest/shared/loading_indicator.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
              : ref.watch(userDataStreamIDProvider(listings[0].agentID)).when(
                  data: (user) {
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
                  },
                  error: (e, stk) {
                    return Text("An error occured");
                  },
                  loading: () {
                    return LoadingIndicator();
                  },
                );
        },
        loading: () {
          return Skeletonizer(
            enabled: true,
            child: ListView(
              children: List.generate(8, (_) {
                return AgentListing(
                  listing: PropertyListing(
                    id: 'id',
                    agentID: 'agentID',
                    address: 'address',
                    propertyType: PropertyType.all,
                    propertySize: 1,
                    price: 1,
                    agentFee: 1,
                    listingType: ListingType.rent,
                    imagesUrls: [],
                    bedrooms: 1,
                    kitchens: 1,
                    bathrooms: 1,
                    sittingRooms: 1,
                    condition: Condition.all,
                    facilities: [],
                    furnishing: Furnishing.furnished,
                    propertySubtype: PropertySubtype.all,
                    geoPoint: GeoPoint(1, 1),
                    state: '',
                    lga: '',
                    available: false,
                  ),
                  agentModel: AgentModel.defaultInstance()
                );
              }),
            ),
          );
        },
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

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/features/btm_nav_bar/client/btm_nav_barC.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/widgets/listing_widget.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/features/user%20setup/views/user_setup.dart';
import 'package:home_quest/models/agent.dart';
import 'package:home_quest/models/property_listing.dart';
import 'package:home_quest/shared/error_screen.dart';
import 'package:home_quest/shared/loading_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/enums.dart';
import '../../btm_nav_bar/agent/btm_nav_barA.dart';

class HomeUserDataWrapper extends ConsumerWidget {
  const HomeUserDataWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDataExistsCtrl).when(
      data: (userExists) {
        log(userExists.toString() + " from home wrapper");
        if (userExists!) {
          return ref.watch(userDataStreamProvider).when(
            data: (user) {
              log(user.runtimeType.toString());
              if (user.runtimeType == AgentModel) {
                return const BtmNavBarA();
              } else {
                return const BtmNavBarC();
              }
            },
            error: (e, stk) {
              log(e.toString());
              log(stk.toString());
              return ErrorScreen(
                errorText: e.toString() + stk.toString(),
                onRefresh: () => ref.refresh(userDataStreamProvider.future),
              );
            },
            loading: () {
              return Scaffold(
                body: Skeletonizer(
                  containersColor: Colors.grey[600],
                  enabled: true,
                  child: ListView(
                    children: [
                      ...List.generate(8, (_) {
                        return ListingWidget(
                          propertyListing: PropertyListing(
                              id: "id",
                              agentID: "agentID",
                              address: 'address',
                              propertyType: PropertyType.all,
                              propertySize: 10,
                              price: 10,
                              agentFee: 10,
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
                              geoPoint: const GeoPoint(1, 1),
                              state: '',
                              lga: '',
                              available: false),
                        );
                      })
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const UserSetup();
        }
      },
      error: (e, stk) {
        return ErrorScreen(
          errorText: e.toString(),
          onRefresh: () => ref.invalidate(userDataExistsCtrl),
        );
      },
      loading: () {
        return const LoadingScreen();
      },
    );
  }
}

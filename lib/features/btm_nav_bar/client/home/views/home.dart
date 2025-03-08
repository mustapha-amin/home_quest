import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:home_quest/core/enums.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/controller/property_listing_ctrl.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/widgets/header_widgets.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/widgets/listing_widget.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/widgets/nearby_listings_widget.dart';
import 'package:home_quest/models/property_listing.dart';
import 'package:home_quest/services/geocoding_service.dart';
import 'package:home_quest/shared/error_screen.dart';
import 'package:home_quest/shared/loading_indicator.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:latlong2/latlong.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  ValueNotifier<String?> state = ValueNotifier(null);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final location = await ref.watch(userLocationProvider.future);
      state.value = (await GeocodingService.reverseCoding(
              LatLng(location.latitude, location.longitude)))!
          .state!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(fetchListingsProvider).when(
      data: (listings) {
        return RefreshIndicator(
          onRefresh: () async => ref.refresh(fetchListingsProvider.future),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                ...listings!
                    .where((listing) => listings.indexOf(listing) < 4)
                    .map((listing) =>
                        ListingWidget(propertyListing: listing).padX(10)),
                ValueListenableBuilder<String?>(
                    valueListenable: state,
                    builder: (context, data, _) {
                      if (data != null) {
                        return SizedBox(
                          height: 25.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              spaceY(10),
                              Text("Listings in ${data.captializeFirst}",
                                      style: kTextStyle(30, isBold: true))
                                  .padX(10),
                              Expanded(
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    ...listings.where((listing) {
                                      return listing.state == data;
                                    }).map((listing) =>
                                        NearbyListingsWidget(listing: listing)
                                            .padX(10)),
                                  ],
                                ),
                              ),
                              spaceY(10),
                            ],
                          ).padX(10),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
                ...listings
                    .where((listing) => listings.indexOf(listing) >= 4)
                    .map((listing) =>
                        ListingWidget(propertyListing: listing).padX(10)),
              ],
            ),
          ),
        );
      },
      error: (e, _) {
        return ErrorScreen(
          errorText: "Error fetching listings: ${e.toString()}",
          onRefresh: () {
            log(e.toString());
            ref.invalidate(fetchListingsProvider);
          },
        );
      },
      loading: () {
        return Skeletonizer(
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
        );
      },
    );
  }
}

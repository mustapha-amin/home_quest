import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/controller/property_listing_ctrl.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/widgets/header_widgets.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/widgets/listing_widget.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/widgets/nearby_listings_widget.dart';
import 'package:home_quest/services/geocoding_service.dart';
import 'package:home_quest/shared/error_screen.dart';
import 'package:home_quest/shared/loading_indicator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(fetchListingsProvider).when(
      data: (listings) {
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(fetchListingsProvider),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                ...listings!
                    .where((listing) => listings.indexOf(listing) < 4)
                    .map((listing) =>
                        ListingWidget(propertyListing: listing).padX(10)),
                ref.watch(userLocationProvider).when(
                  data: (location) {
                    return FutureBuilder(
                      future: GeocodingService.reverseCoding(
                          LatLng(location.latitude, location.longitude)),
                      builder: (ctx, snap) {
                        if (snap.hasData &&
                            listings
                                    .where((listing) =>
                                        listing.state == snap.data!.state)
                                    .length >
                                1) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Listings in ${snap.data!.state!.captializeFirst}",
                                      style: kTextStyle(30, isBold: true))
                                  .padX(10),
                              SizedBox(
                                height: 20.h,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    ...listings.where((listing) {
                                      return listing.state == snap.data!.state;
                                    }).map((listing) =>
                                        NearbyListingsWidget(listing: listing)
                                            .padX(10)),
                                  ],
                                ),
                              ),
                            ],
                          ).padX(10);
                        } else if (snap.hasError) {
                          return Text("Error fetching listings");
                        }
                        return const LoadingIndicator();
                      },
                    );
                  },
                  loading: () {
                    return const LoadingIndicator();
                  },
                  error: (e, _) {
                    return Text("Error fetching location: ${e.toString()}");
                  },
                ),
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
        return const Center(child: LoadingIndicator());
      },
    );
  }
}

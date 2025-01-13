import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/controller/property_listing_ctrl.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/widgets/listing_widget.dart';
import 'package:home_quest/shared/error_screen.dart';
import 'package:home_quest/shared/loading_indicator.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(fetchListingsProvider).when(
      data: (listings) {
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(fetchListingsProvider),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ...listings!.map((listing) =>
                    ListingWidget(propertyListing: listing).padX(10)),
                ...listings.map((listing) =>
                    ListingWidget(propertyListing: listing).padX(10)),
                ...listings.map((listing) =>
                    ListingWidget(propertyListing: listing).padX(10)),
              ],
            ),
          ),
        );
      },
      error: (e, _) {
        return ErrorScreen(
          errorText: "Error fetching listings",
          onRefresh: () {
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

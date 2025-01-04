import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/controller/property_listing_ctrl.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/widgets/listing_widget.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/models/client.dart';
import 'package:home_quest/shared/loading_indicator.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDataStreamProvider);
    return Scaffold(
      body: ref.watch(fetchListingsProvider).when(
        data: (listings) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ...listings!
                    .where((listing) =>
                        (user as ClientModel).bookmarks.contains(listing.id))
                    .map((listing) => ListingWidget(propertyListing: listing))
              ],
            ),
          );
        },
        error: (e, stk) {
          return const Text("An error occured");
        },
        loading: () {
          return const LoadingIndicator();
        },
      ),
    );
  }
}

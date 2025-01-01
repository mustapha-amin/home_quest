import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/controller/property_listing_ctrl.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/widgets/listing_widget.dart';
import 'package:home_quest/shared/loading_indicator.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(fetchListingsProvider).when(
        data: (listings) {
          return SingleChildScrollView(
            child: Column(
              children: [
                for (int i = 0; i < 10; i++)
                  ListingWidget(propertyListing: listings[0]),
              ],
            ),
          );
        },
        error: (e, _) {
          return const Center(
            child: Text("An error occured"),
          );
        },
        loading: () {
          return const Center(child: LoadingIndicator());
        },
      ),
    );
  }
}

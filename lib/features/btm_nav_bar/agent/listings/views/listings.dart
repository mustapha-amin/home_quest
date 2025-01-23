import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/controller/property_listing_ctrl.dart';
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
                  : ListView.separated(
                      itemCount: listings.length,
                      itemBuilder: (context, index) {
                        return AgentListing(listing: listings[index])
                            .padX(10)
                            .padY(8);
                      },
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                    );
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

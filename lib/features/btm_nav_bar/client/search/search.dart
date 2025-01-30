import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/controller/property_listing_ctrl.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/widgets/listing_widget.dart';
import 'package:home_quest/features/btm_nav_bar/client/search/controller/search_filter_ctrl.dart';
import 'package:home_quest/shared/error_screen.dart';
import 'package:home_quest/shared/loading_indicator.dart';

import '../../../../core/utils/textstyle.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return !ref.watch(searchFilterProvider).searching
        ? Center()
        : ref
            .watch(fetchListingsWithFiltersProvider(
                ref.watch(searchFilterProvider).filter))
            .when(
            data: (listings) {
              return listings.isEmpty
                  ? Center(
                      child: Text("No listings matched your criteria", style: kTextStyle(20, isBold: true),),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          ...listings.map(
                            (listing) =>
                                ListingWidget(propertyListing: listing),
                          ),
                        ],
                      ),
                    );
            },
            error: (e, stk) {
              log(e.toString());
              return ErrorScreen(
                errorText: e.toString(),
                onRefresh: () => ref.invalidate(
                  fetchListingsWithFiltersProvider(
                    ref.watch(searchFilterProvider).filter,
                  ),
                ),
              );
            },
            loading: () {
              return const LoadingIndicator();
            },
          );
  }
}

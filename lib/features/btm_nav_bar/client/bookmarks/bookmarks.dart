import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/widgets/listing_widget.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/models/client.dart';
import 'package:home_quest/shared/loading_indicator.dart';

import '../home/widgets/bookmarked_listing_widget.dart';
import 'controllers/bookmark_ctrl.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(userDataStreamProvider).when(
      data: (user) {
        return ref
            .watch(fetchFavsProvider((user as ClientModel).bookmarks))
            .when(
          data: (listings) {
            return listings.isEmpty
                ? Center(
                    child: Text(
                    "No bookmarks yet",
                    style: kTextStyle(20, isBold: true),
                  ))
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ...listings.map((listing) =>
                            BookmarkedListingWidget(propertyListing: listing, onRemoveBookmark: () {},))
                      ],
                    ).padX(10),
                  );
          },
          error: (e, stk) {
            log(e.toString(), stackTrace: stk);
            return Text(e.toString());
          },
          loading: () {
            return const LoadingIndicator();
          },
        );
      },
      error: (e, stk) {
        return const Text("Error fetching user data");
      },
      loading: () {
        return const LoadingIndicator();
      },
    );
  }
}

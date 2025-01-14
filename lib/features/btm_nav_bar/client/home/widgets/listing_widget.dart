import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/controllers/controllers.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/views/listing_detail.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/models/client.dart';
import 'package:home_quest/models/property_listing.dart';
import 'package:home_quest/shared/loading_indicator.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:sizer/sizer.dart';
import '../../../../../core/enums.dart';
import '../../bookmarks/controllers/bookmark_ctrl.dart';

class ListingWidget extends ConsumerWidget {
  final PropertyListing propertyListing;
  final bool isViewDetails;
  const ListingWidget({
    required this.propertyListing,
    this.isViewDetails = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => context.push(
        ListingDetail(
          propertyListing: propertyListing,
          isViewDetails: isViewDetails,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 23.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      propertyListing.imagesUrls[0],
                    ),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: ref.watch(userDataStreamProvider).when(
                      data: (userFromStream) {
                        ClientModel user = userFromStream as ClientModel;
                        bool isBookmarked =
                            user.bookmarks.contains(propertyListing.id);
                        return IconButton.filledTonal(
                          onPressed: () {
                            ref.read(updateBookmarksProv((
                              listing: propertyListing,
                              bookmarks: user.bookmarks,
                              id: propertyListing.id,
                              isAddition: !isBookmarked,
                            )));
                          },
                          icon: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_outline,
                          ),
                        );
                      },
                      error: (e, s) => Text("Error"),
                      loading: () => const LoadingIndicator(),
                    ),
              )
            ],
          ),
          spaceY(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: propertyListing.listingType == ListingType.rent
                              ? Colors.green
                              : Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      spaceX(5),
                      Text(
                        "For ${propertyListing.listingType.name}",
                        style: kTextStyle(15),
                      ),
                    ],
                  ),
                  Text(
                    "${propertyListing.price.toMoney} ${propertyListing.listingType == ListingType.rent ? ' / Year' : ''}",
                    style: kTextStyle(18, isBold: true),
                  ),
                  SizedBox(
                    width: 35.w,
                    child: Text(
                      propertyListing.address,
                      style: kTextStyle(15),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ).padAll(12),
    );
  }
}

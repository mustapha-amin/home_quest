import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/models/client.dart';
import 'package:home_quest/models/property_listing.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:sizer/sizer.dart';
import '../../../../../core/enums.dart';
import '../../bookmarks/controllers/bookmark_ctrl.dart';
import '../views/listing_detail.dart';

class BookmarkedListingWidget extends ConsumerWidget {
  final PropertyListing propertyListing;
  final Function() onRemoveBookmark;

  const BookmarkedListingWidget({
    required this.propertyListing,
    required this.onRemoveBookmark,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(propertyListing.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onRemoveBookmark(),
      child: InkWell(
        onTap: () => {
          log(propertyListing.toString()),
          context.push(
            ListingDetail(
              propertyListing: propertyListing,
              isViewDetails: true,
            ),
          )
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              Container(
                height: 15.h,
                width: 35.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(propertyListing.imagesUrls[0]),
                  ),
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(15)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: propertyListing.listingType ==
                                      ListingType.rent
                                  ? Colors.green
                                  : Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          spaceX(5),
                          Text(
                            "For ${propertyListing.listingType.name.captializeFirst} - ${propertyListing.condition.name.captializeFirst}",
                            style: kTextStyle(13),
                          ),
                        ],
                      ),
                      spaceY(4),
                      Text(
                        "${propertyListing.price.toMoney}${propertyListing.listingType == ListingType.rent ? '/Year' : ''}",
                        style: kTextStyle(20, isBold: true),
                      ),
                      spaceY(4),
                      Text(
                        propertyListing.address,
                        style: kTextStyle(13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              IconButton.outlined(
                onPressed: () {
                  ref.read(updateBookmarksProv((
                    context: context,
                    listing: propertyListing,
                    bookmarks:
                        (ref.watch(userDataStreamProvider).value as ClientModel)
                            .bookmarks,
                    id: propertyListing.id,
                    isAddition: false,
                  )));
                },
                icon: Icon(Icons.bookmark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

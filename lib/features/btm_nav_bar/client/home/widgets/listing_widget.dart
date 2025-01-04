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

import '../../../../../core/colors.dart';
import '../../../../../core/enums.dart';

class ListingWidget extends ConsumerStatefulWidget {
  final PropertyListing propertyListing;
  final bool isViewDetails;
  const ListingWidget({
    required this.propertyListing,
    this.isViewDetails = false,
    super.key,
  });

  @override
  ConsumerState<ListingWidget> createState() => _ListingWidgetState();
}

class _ListingWidgetState extends ConsumerState<ListingWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(
        ListingDetail(
          propertyListing: widget.propertyListing,
          isViewDetails: widget.isViewDetails,
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
                      widget.propertyListing.imagesUrls[0],
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
                        if ((userFromStream as ClientModel)
                            .bookmarks
                            .contains(widget.propertyListing.id)) {
                          return IconButton.filledTonal(
                            onPressed: () {
                              ref.read(
                                removeFavsProvider(
                                  (
                                    ctx: context,
                                    id: widget.propertyListing.id,
                                    user: userFromStream
                                  ),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  padding: EdgeInsets.all(6),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.white,
                                  content: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 10.w,
                                        height: 10.w,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              widget.propertyListing
                                                  .imagesUrls[0],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text("Removed from bookmarks", style: kTextStyle(16),)
                                    ],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.bookmark,
                              color: AppColors.brown,
                            ),
                          );
                        }
                        return IconButton.filledTonal(
                          onPressed: () {
                            ref.read(
                              addToFavsProvider(
                                (
                                  ctx: context,
                                  id: widget.propertyListing.id,
                                  user: userFromStream
                                ),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  padding: EdgeInsets.all(6),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.white,
                                  content: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 10.w,
                                        height: 10.w,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              widget.propertyListing
                                                  .imagesUrls[0],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text("Added to bookmarks", style: kTextStyle(16),)
                                    ],
                                  ),
                                ),
                              );
                          },
                          icon: const Icon(Icons.bookmark_outline),
                        );
                      },
                      error: (e, s) => IconButton.filledTonal(
                        onPressed: () {},
                        icon: const Icon(Icons.bookmark_outline),
                      ),
                      loading: () => const LoadingIndicator(),
                    ),
              ),
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
                          color: widget.propertyListing.listingType ==
                                  ListingType.rent
                              ? Colors.green
                              : Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      spaceX(5),
                      Text(
                        "For ${widget.propertyListing.listingType.name}",
                        style: kTextStyle(15),
                      ),
                    ],
                  ),
                  Text(
                    "${widget.propertyListing.price.toMoney} ${widget.propertyListing.listingType == ListingType.rent ? ' / Year' : ''}",
                    style: kTextStyle(18, isBold: true),
                  ),
                  SizedBox(
                    width: 35.w,
                    child: Text(
                      widget.propertyListing.address,
                      style: kTextStyle(15),
                    ),
                  ),
                ],
              ),
              OutlinedButton(
                onPressed: () {
                  context.push(ListingDetail(
                    propertyListing: widget.propertyListing,
                    isViewDetails: widget.isViewDetails,
                  ));
                },
                child: Text(
                  "View details",
                  style: kTextStyle(17),
                ),
              )
            ],
          )
        ],
      ).padAll(12),
    );
  }
}

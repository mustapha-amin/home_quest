import 'package:flutter/material.dart';

import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/views/listing_detail.dart';
import 'package:home_quest/models/property_listing.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../../../../../core/enums.dart';

class ListingWidget extends StatefulWidget {
  final PropertyListing propertyListing;
  final bool isViewDetails;
  const ListingWidget({
    required this.propertyListing,
    this.isViewDetails = false,
    super.key,
  });

  @override
  State<ListingWidget> createState() => _ListingWidgetState();
}

class _ListingWidgetState extends State<ListingWidget> {
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
                child: IconButton.filledTonal(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
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

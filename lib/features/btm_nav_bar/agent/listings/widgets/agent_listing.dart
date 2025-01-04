import 'package:flutter/material.dart';
import 'package:home_quest/core/enums.dart';
import 'package:home_quest/models/property_listing.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../../../../core/utils/textstyle.dart';

class AgentListing extends StatelessWidget {
  final PropertyListing listing;
  const AgentListing({required this.listing, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                width: 28.w,
                height: 15.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(listing.imagesUrls[0]),
                    fit: BoxFit.fitHeight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Container(
                height: 30,
                decoration: BoxDecoration(
                  color: listing.listingType == ListingType.rent
                      ? Colors.green
                      : Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Text(
                    '     ${listing.listingType.name}    ',
                    style: kTextStyle(15, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          spaceX(8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              listing.propertySubtype.name[0].toUpperCase() +
                                  listing.propertySubtype.name
                                      .substring(1)
                                      .toLowerCase(),
                              style: kTextStyle(20,
                                  isBold: true, color: Colors.black)),
                          Icon(Icons.delete, color: Colors.red, size: 28),
                        ],
                      ),
                      spaceY(8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 20,
                          ),
                          Text(
                            listing.lga + ", " + listing.state,
                            style: kTextStyle(15, color: Colors.grey[700]!),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedBedSingle02,
                            color: Colors.blue,
                            size: 20,
                          ),
                          Text(
                            listing.bedrooms.toString() + " Bedrooms",
                            style: kTextStyle(15, color: Colors.black),
                          ),
                          spaceX(5),
                          HugeIcon(
                              icon: HugeIcons.strokeRoundedBathtub01,
                              color: Colors.blue,
                              size: 20),
                          Text(
                            listing.bathrooms.toString() + " Bathrooms",
                            style: kTextStyle(15, color: Colors.black),
                          ),
                        ],
                      ),
                      spaceY(5),
                      Row(
                        children: [
                          HugeIcon(
                              icon: HugeIcons.strokeRoundedTapeMeasure,
                              color: Colors.blue,
                              size: 20),
                          Text(
                            listing.propertySize.toString() + " sqm",
                            style: kTextStyle(15, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        NumberFormat.currency(symbol: 'N', decimalDigits: 0)
                            .format(listing.price),
                        style:
                            kTextStyle(18, isBold: true, color: Colors.black),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'View Details',
                          style: kTextStyle(16, color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

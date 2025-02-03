import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/enums.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/controller/property_listing_ctrl.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/views/add_listings.dart';
import 'package:home_quest/models/agent.dart';
import 'package:home_quest/models/property_listing.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../../../../core/utils/textstyle.dart';

class AgentListing extends ConsumerWidget {
  final PropertyListing listing;
  final AgentModel agentModel;
  const AgentListing(
      {required this.listing, required this.agentModel, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Text(
                    listing.available ? '     ${listing.listingType.name}    ' : listing.listingType == ListingType.rent ? 
                      "     Rented out     "
                     : "     Sold out     ",
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
                          PopupMenuButton(
                              padding: EdgeInsets.zero,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.more_vert)),
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    child: Text(
                                      "Delete",
                                      style: kTextStyle(14),
                                    ),
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                "Delete listing",
                                                style: kTextStyle(20,
                                                    isBold: true),
                                              ),
                                              content: SizedBox(
                                                width: 80.w,
                                                child: Text(
                                                  "Do you want to delete this property",
                                                  style: kTextStyle(15),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    ref.read(
                                                        deleteListingProvider(
                                                            listing.id));
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "Yes",
                                                    style: kTextStyle(
                                                      15,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "No",
                                                    style: kTextStyle(15),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: Text(
                                      "${listing.available ? 'M' : 'Un'}ark as ${listing.listingType == ListingType.rent ? 'Rented out' : 'Sold out'}",
                                      style: kTextStyle(14),
                                    ),
                                    onTap: () {
                                      ref.read(updateListingStatusProvider(
                                          (listing, agentModel)));
                                    },
                                  ),
                                ];
                              })
                        ],
                      ),
                      spaceY(8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 20,
                          ),
                          Text(
                            "${listing.lga}, ${listing.state}",
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
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedBedSingle02,
                            color: Colors.blue,
                            size: 20,
                          ),
                          Text(
                            "${listing.bedrooms} Bedrooms",
                            style: kTextStyle(15, color: Colors.black),
                          ),
                          spaceX(5),
                          const HugeIcon(
                              icon: HugeIcons.strokeRoundedBathtub01,
                              color: Colors.blue,
                              size: 20),
                          Text(
                            "${listing.bathrooms} Bathrooms",
                            style: kTextStyle(15, color: Colors.black),
                          ),
                        ],
                      ),
                      spaceY(5),
                      Row(
                        children: [
                          const HugeIcon(
                              icon: HugeIcons.strokeRoundedTapeMeasure,
                              color: Colors.blue,
                              size: 20),
                          Text(
                            "${listing.propertySize} sqm",
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
                        listing.price.toMoney,
                        style:
                            kTextStyle(18, isBold: true, color: Colors.black),
                      ),
                      InkWell(
                        onTap: () {
                          context.push(AddListings(
                            propertyListingArg: listing,
                          ));
                        },
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

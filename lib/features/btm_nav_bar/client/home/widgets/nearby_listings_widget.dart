import 'package:flutter/material.dart';
import 'package:home_quest/core/enums.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/views/listing_detail.dart';
import 'package:home_quest/models/property_listing.dart';
import 'package:sizer/sizer.dart';

class NearbyListingsWidget extends StatelessWidget {
  final PropertyListing listing;
  const NearbyListingsWidget({required this.listing, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(ListingDetail(propertyListing: listing)),
      child: SizedBox(
        width: 50.w,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      fit: BoxFit.cover,
                      listing.imagesUrls[0],
                    ),
                  ),
                ),
                Text.rich(TextSpan(
                    text: listing.price.toMoney,
                    style: kTextStyle(20, isBold: true),
                    children: [
                      TextSpan(
                        text: listing.listingType == ListingType.rent
                            ? ' / Year'
                            : '',
                        style: kTextStyle(14, isBold: true),
                      )
                    ])),
                Text(
                  "${listing.lga}, ${listing.state}",
                  style: kTextStyle(15),
                )
              ],
            ),
            Container(
              height: 30,
              width: 15.w,
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
                  listing.listingType.name,
                  style: kTextStyle(18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

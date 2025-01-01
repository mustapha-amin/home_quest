import 'package:flutter/material.dart';
import 'package:home_quest/core/extensions/widget_exts.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/models/property_listing.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class ListingWidget extends StatelessWidget {
  final PropertyListing propertyListing;
  const ListingWidget({
    required this.propertyListing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[100],
      elevation: 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 30.h,
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
                          color: Colors.green,
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
                    "${NumberFormat.currency(symbol: '₦', decimalDigits: 0).format(propertyListing.price)} / Year",
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
              OutlinedButton(
                  onPressed: () {}, child: Text("Check availability"))
            ],
          )
        ],
      ).padAll(12),
    );
  }
}

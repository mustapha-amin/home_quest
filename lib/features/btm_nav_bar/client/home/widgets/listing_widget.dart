import 'package:flutter/material.dart';
import 'package:home_quest/models/property_listing.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sizer/sizer.dart';

class ListingWidget extends StatelessWidget {
  final PropertyListing propertyListing;
  const ListingWidget({
    required this.propertyListing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    propertyListing.imagesUrls[0],
                  ),
                ),
                borderRadius: BorderRadius.circular(10),
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
        Text("For ${propertyListing.listingType.name}"),
        Text("₦${propertyListing.price} / Year"),
        SizedBox(
          width: 25.w,
          child: Text(propertyListing.address),
        ),
      ],
    );
  }
}

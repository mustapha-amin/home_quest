import 'package:flutter/material.dart';
import 'package:home_quest/models/property_listing.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sizer/sizer.dart';

class ListingDetail extends StatelessWidget {
  final PropertyListing propertyListing;
  const ListingDetail({required this.propertyListing, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 28.h,
            leading: const HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01, color: Colors.black),
            flexibleSpace: FlexibleSpaceBar(
                background: CarouselView(
              itemExtent: double.infinity,
              children: [
                ...propertyListing.imagesUrls.map(
                  (url) => Image.network(url),
                )
              ],
            )),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [],
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/utils/image_path.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/views/agent_detail.dart';

import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/models/client.dart';
import 'package:home_quest/models/property_listing.dart';
import 'package:home_quest/services/geocoding_service.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/enums.dart';
import '../../../../../core/utils/safety_tips_text.dart';
import '../../../../../core/utils/textstyle.dart';
import '../../../../../shared/attribution_widget.dart';
import '../../../../../shared/loading_indicator.dart';
import '../../../../../shared/spacing.dart';
import '../../bookmarks/controllers/bookmark_ctrl.dart';

class ListingDetail extends ConsumerStatefulWidget {
  final PropertyListing propertyListing;
  final bool isViewDetails;
  const ListingDetail(
      {required this.propertyListing, this.isViewDetails = false, super.key});

  @override
  ConsumerState<ListingDetail> createState() => _ListingDetailState();
}

class _ListingDetailState extends ConsumerState<ListingDetail> {
  PageController pageController = PageController();
  int _currentIndex = 0;

  String whatsappMsgGen() {
    return "Hi! I'm interested in ${widget.propertyListing.listingType == ListingType.rent ? "renting " : "buying "}"
        "the house situated at ${widget.propertyListing.address} and available at ${widget.propertyListing.price.toMoney}${widget.propertyListing.listingType == ListingType.rent ? '/year' : ''} "
        "on the HomeQuest app. "
        "Could you tell me about availability and scheduling a viewing?";
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 28.h,
                    toolbarHeight: 5.h,
                    backgroundColor: Colors.white,
                    leading: IconButton.filledTonal(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        context.pop();
                      },
                      icon: const HugeIcon(
                          icon: HugeIcons.strokeRoundedArrowLeft01,
                          color: Colors.black),
                    ),
                    actions: [
                      ref.watch(userDataStreamProvider).when(
                            data: (userFromStream) {
                              ClientModel user = userFromStream as ClientModel;
                              bool isBookmarked = user.bookmarks
                                  .contains(widget.propertyListing.id);
                              return IconButton.filledTonal(
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  ref.read(updateBookmarksProv((
                                    context: context,
                                    listing: widget.propertyListing,
                                    bookmarks: user.bookmarks,
                                    id: widget.propertyListing.id,
                                    isAddition: !isBookmarked,
                                  )));
                                },
                                icon: Icon(
                                  isBookmarked
                                      ? Icons.bookmark
                                      : Icons.bookmark_outline,
                                  size: 30,
                                ),
                              );
                            },
                            error: (e, s) => IconButton.filledTonal(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.bookmark_outline,
                                size: 30,
                              ),
                            ),
                            loading: () => const LoadingIndicator(),
                          ),
                      PopupMenuButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          elevation: 1,
                          color: Colors.white,
                          menuPadding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 2),
                          icon: const Icon(
                            Icons.more_horiz,
                            color: Colors.black,
                            size: 30,
                          ),
                          itemBuilder: (context) {
                            return [
                              const PopupMenuItem(
                                child: Text("Report"),
                              ),
                            ];
                          })
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        PageView(
                          scrollDirection: Axis.horizontal,
                          controller: pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          children: [
                            ...widget.propertyListing.imagesUrls.map(
                              (url) => Image.network(
                                url,
                                fit: BoxFit.cover,
                              ),
                            )
                          ],
                        ),
                        Badge(
                          backgroundColor: Colors.black.withOpacity(0.6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          label: Text(
                            '${_currentIndex + 1} / ${widget.propertyListing.imagesUrls.length}',
                            style: kTextStyle(13, color: Colors.white),
                          ),
                        ).padAll(8)
                      ],
                    )),
                  ),
                  SliverPadding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          if (!widget.isViewDetails)
                            ref
                                .watch(userDataStreamIDProvider(
                                    widget.propertyListing.agentID))
                                .when(data: (agent) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        NetworkImage(agent!.profilePicture),
                                  ).padX(5),
                                  Text(agent.name, style: kTextStyle(18)),
                                  spaceX(5),
                                  InkWell(
                                    onTap: () {
                                      context.push(AgentDetail(id: agent.id));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "View profile",
                                        style: kTextStyle(15),
                                      ).padX(8).padY(5),
                                    ),
                                  )
                                ],
                              );
                            }, error: (e, stk) {
                              log(e.toString(), stackTrace: stk);
                              return const Text("An error occured");
                            }, loading: () {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }),
                          spaceY(10),
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
                          spaceY(20),
                          Text(
                            "${widget.propertyListing.price.toMoney} ${widget.propertyListing.listingType == ListingType.rent ? ' / Year' : ''}",
                            style: kTextStyle(18,
                                isBold: true, color: Colors.grey[800]!),
                          ),
                          Text(
                              "Agent fee: ${widget.propertyListing.agentFee.toMoney}",
                              style: kTextStyle(15, color: Colors.grey[800]!)),
                          spaceY(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 20,
                              ),
                              Text(
                                "${widget.propertyListing.address} ${widget.propertyListing.lga}, ${widget.propertyListing.state}",
                                style: kTextStyle(15, color: Colors.grey[700]!),
                              ),
                            ],
                          ),
                          spaceY(10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    const HugeIcon(
                                      icon: HugeIcons.strokeRoundedBedSingle02,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                    Text(
                                      "${widget.propertyListing.bedrooms} Bedrooms",
                                      style:
                                          kTextStyle(15, color: Colors.black),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const HugeIcon(
                                        icon: HugeIcons.strokeRoundedBathtub01,
                                        color: Colors.blue,
                                        size: 20),
                                    Text(
                                      "${widget.propertyListing.bathrooms} Bathrooms",
                                      style:
                                          kTextStyle(15, color: Colors.black),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const HugeIcon(
                                        icon: HugeIcons
                                            .strokeRoundedKitchenUtensils,
                                        color: Colors.blue,
                                        size: 20),
                                    Text(
                                      "${widget.propertyListing.kitchens} Kitchens",
                                      style:
                                          kTextStyle(15, color: Colors.black),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const HugeIcon(
                                      icon: HugeIcons.strokeRoundedSofa01,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                    Text(
                                      "${widget.propertyListing.sittingRooms} Sitting Room${widget.propertyListing.sittingRooms == 1 ? '' : 's'}",
                                      style:
                                          kTextStyle(15, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ).padY(20),
                          ),
                          spaceY(10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    _buildFeature(
                                        "Subtype",
                                        widget.propertyListing.propertySubtype
                                            .name),
                                    _buildFeature(
                                        "Subtype",
                                        widget.propertyListing.propertySubtype
                                            .name),
                                  ],
                                ),
                                Row(
                                  children: [
                                    _buildFeature("Size",
                                        "${widget.propertyListing.propertySize} sqm"),
                                    _buildFeature("Furnishing",
                                        widget.propertyListing.furnishing.name),
                                  ],
                                ),
                                Row(
                                  children: [
                                    _buildFeature("Condition",
                                        widget.propertyListing.condition.name),
                                    _buildFeature(
                                        "Facilities",
                                        widget.propertyListing.facilities
                                            .map((fac) => fac.name)
                                            .join(", ")),
                                  ],
                                ),
                              ],
                            ).padY(20).padX(10),
                          ),
                          spaceY(10),
                          SizedBox(
                              width: double.infinity,
                              height: 30.h,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    FlutterMap(
                                      options: MapOptions(
                                        initialCenter: LatLng(
                                            widget.propertyListing.geoPoint
                                                .latitude,
                                            widget.propertyListing.geoPoint
                                                .longitude),
                                        initialZoom: 17,
                                        minZoom: 10,
                                      ),
                                      children: [
                                        TileLayer(
                                          urlTemplate:
                                              'https://api.mapbox.com/styles/v1/mustyameen/cm4tu2iyy002r01s18ylrerzd/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibXVzdHlhbWVlbiIsImEiOiJjbTRucTJjNmIwYjJsMmpxc3R5bGEwcm1mIn0.O8Jpsml14mA7jpVLFvmcbg',
                                          userAgentPackageName:
                                              'com.mustapha.homequest',
                                          additionalOptions: const {
                                            "accessToken":
                                                "pk.eyJ1IjoibXVzdHlhbWVlbiIsImEiOiJjbTRucTJjNmIwYjJsMmpxc3R5bGEwcm1mIn0.O8Jpsml14mA7jpVLFvmcbg",
                                            "id":
                                                "mapbox://styles/mustyameen/cm4tu2iyy002r01s18ylrerzd"
                                          },
                                        ),
                                        MarkerLayer(markers: [
                                          Marker(
                                            point: LatLng(
                                                widget.propertyListing.geoPoint
                                                    .latitude,
                                                widget.propertyListing.geoPoint
                                                    .longitude),
                                            child: HugeIcon(
                                              icon: Icons.location_on,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                          )
                                        ])
                                      ],
                                    ),
                                    const AttributionWidget(),
                                  ],
                                ),
                              )),
                              spaceY(40),
                          Text(
                            "Safety tips",
                            style: kTextStyle(20, isBold: true),
                          ),
                          spaceY(10),
                          Text(
                            safetyTipsText,
                            style: kTextStyle(15),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 8.h,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40.w,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await launchUrl(
                          Uri.parse(
                            Uri.encodeFull(
                                "https://wa.me/+234${ref.watch(userDataStreamIDProvider(widget.propertyListing.agentID)).value!.phoneNumber}}?text=${whatsappMsgGen()} "),
                          ),
                        );
                      },
                      label: Text(
                        "Message Agent",
                        style: kTextStyle(15, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        backgroundColor: Colors.green,
                      ),
                      icon: const HugeIcon(
                        icon: HugeIcons.strokeRoundedWhatsapp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40.w,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await launchUrl(
                          Uri(
                            scheme: 'tel',
                            path:
                                '0${ref.watch(userDataStreamIDProvider(widget.propertyListing.agentID)).value!.phoneNumber}',
                          ),
                        );
                      },
                      label: Text(
                        "Call Agent",
                        style: kTextStyle(15),
                      ),
                      icon: const HugeIcon(
                          icon: HugeIcons.strokeRoundedCall,
                          color: Colors.black),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildFeature(String title, String value) {
  return SizedBox(
    width: 40.w,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: kTextStyle(15, isBold: true)),
        spaceX(5),
        Text(value, style: kTextStyle(15, color: Colors.grey[700]!)),
      ],
    ).padY(5),
  );
}

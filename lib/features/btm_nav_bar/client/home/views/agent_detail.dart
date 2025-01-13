import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/controller/property_listing_ctrl.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/widgets/listing_widget.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/models/agent.dart';
import 'package:home_quest/shared/loading_indicator.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../shared/spacing.dart';

class AgentDetail extends ConsumerStatefulWidget {
  final String id;
  const AgentDetail({required this.id, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AgentDetailState();
}

class _AgentDetailState extends ConsumerState<AgentDetail> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Agent Detail',
            style: kTextStyle(18, isBold: true),
          ),
          centerTitle: true,
          forceMaterialTransparency: true,
        ),
        body: ref.watch(userDataStreamIDProvider(widget.id)).when(
              data: (userFromStream) {
                AgentModel user = userFromStream as AgentModel;
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(user.profilePicture),
                          ),
                          Text(
                            user.name,
                            style: kTextStyle(20, isBold: true).copyWith(
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      TabBar(
                        tabs: [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedPropertyNew,
                                  color: Colors.black,
                                ),
                                spaceX(5),
                                Text(
                                  'Listings',
                                  style: kTextStyle(16),
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedComment01,
                                  color: Colors.black,
                                ),
                                spaceX(5),
                                Text(
                                  'Reviews',
                                  style: kTextStyle(16),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ref
                                .watch(
                                    fetchListingsByAgentIDProvider(widget.id))
                                .when(
                              data: (listings) {
                                return ListView.builder(
                                  itemCount: listings.length,
                                  itemBuilder: (context, index) {
                                    return ListingWidget(
                                      propertyListing: listings[index],
                                      isViewDetails: true,
                                    );
                                  },
                                );
                              },
                              error: (e, stk) {
                                return Center(
                                  child: Text('Error fetching listings'),
                                );
                              },
                              loading: () {
                                return LoadingIndicator();
                              },
                            ),
                            Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: 20,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text('Review ${index + 1}'),
                                        subtitle: Text(
                                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec nec odio vitae libero.'),
                                      );
                                    },
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        
                                      ),
                                    ),
                                    IconButton.filled(
                                      onPressed: () {},
                                      icon: Icon(Icons.send),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ).padX(8).padY(5),
                );
              },
              loading: () => LoadingIndicator(),
              error: (error, stackTrace) => Text('Error: $error'),
            ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/core/utils/app_snackbar.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/controller/property_listing_ctrl.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/controllers/controllers.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/views/image_full_screen.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/widgets/agent_data_widget.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/widgets/agent_details_tab_bar.dart';
import 'package:home_quest/features/btm_nav_bar/client/home/widgets/listing_widget.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/models/agent.dart';
import 'package:home_quest/models/review.dart';
import 'package:home_quest/shared/loading_indicator.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

import '../../../../../shared/spacing.dart';

class AgentDetail extends ConsumerStatefulWidget {
  final String id;
  const AgentDetail({required this.id, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AgentDetailState();
}

class _AgentDetailState extends ConsumerState<AgentDetail> {
  TextEditingController reviewCtrl = TextEditingController();
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    bool submisionLoading = false;
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
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    DefaultTabController(
                      length: 2,
                      child: NestedScrollView(
                        body: AgentDetailsTabBar(agentID: widget.id),
                        headerSliverBuilder: (context, _) => [
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AgentDataWidget(
                                      id: widget.id,
                                      user: user,
                                      onPressed: (value) {
                                        ref
                                            .read(ratingProvider.notifier)
                                            .state = value + 1;
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Write a review"),
                                                content: SizedBox(
                                                  width: 70.w,
                                                  child: TextField(
                                                    controller: reviewCtrl,
                                                    maxLines: 5,
                                                    minLines: 1,
                                                    maxLength: 500,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .sentences,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        "Cancel",
                                                        style: kTextStyle(15),
                                                      )),
                                                  TextButton(
                                                    onPressed: () {
                                                      final uid = ref
                                                          .watch(
                                                              firebaseAuthProvider)
                                                          .currentUser!
                                                          .uid;
                                                      final review = Review(
                                                          userID: uid,
                                                          reviewID:
                                                              const Uuid().v4(),
                                                          text: reviewCtrl.text
                                                              .trim(),
                                                          rating: ref.watch(
                                                              ratingProvider));
                                                      try {
                                                        setState(() {
                                                          submisionLoading =
                                                              true;
                                                        });
                                                        ref.watch(
                                                            updateReviewsProvider((
                                                          review,
                                                          widget.id
                                                        )));
                                                        Navigator.of(context)
                                                            .pop();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        "Review submitted")));
                                                      } on Exception catch (_) {
                                                        showSnackBar(
                                                            "Failed to submit review", context);
                                                      } finally {
                                                        submisionLoading =
                                                            false;
                                                      }
                                                    },
                                                    child: Text(
                                                      "Submit",
                                                      style: kTextStyle(15),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                    spaceY(10),
                                    TabBar(
                                      tabs: [
                                        Tab(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const HugeIcon(
                                                icon: HugeIcons
                                                    .strokeRoundedPropertyNew,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const HugeIcon(
                                                icon: HugeIcons
                                                    .strokeRoundedComment01,
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
                                  ],
                                ).padX(8).padY(5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (submisionLoading) const LoadingIndicator()
                  ],
                );
              },
              loading: () => const LoadingIndicator(),
              error: (error, stackTrace) => Text('Error: ${error.toString()}'),
            ),
      ),
    );
  }
}

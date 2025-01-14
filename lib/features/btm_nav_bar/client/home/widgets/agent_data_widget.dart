import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/models/agent.dart';

import '../../../../../core/utils/textstyle.dart';
import '../../../../../shared/spacing.dart';
import '../../../agent/listings/controller/property_listing_ctrl.dart';
import '../views/image_full_screen.dart';

final ratingProvider = StateProvider.autoDispose((ref) {
  return 0;
});

class AgentDataWidget extends ConsumerStatefulWidget {
  final String id;
  final AgentModel user;
  final void Function(int) onPressed;
  const AgentDataWidget({
    required this.id,
    required this.user,
    required this.onPressed,
    super.key,
  });

  @override
  ConsumerState<AgentDataWidget> createState() => _AgentDataWidgetState();
}

class _AgentDataWidgetState extends ConsumerState<AgentDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: widget.user.profilePicture,
          child: GestureDetector(
            onTap: () => context.push(
              ImageFullScreen(
                url: widget.user.profilePicture,
              ),
            ),
            child: CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(widget.user.profilePicture),
            ),
          ),
        ),
        Text(
          widget.user.name,
          style: kTextStyle(30, isBold: true).copyWith(
            letterSpacing: 2,
          ),
        ),
        spaceY(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.user.reviews.isEmpty
                      ? '0.0'
                      : (widget.user.reviews
                                  .map((review) => review.rating)
                                  .fold(0, (prev, next) => prev + next) /
                              widget.user.reviews.length)
                          .toString(),
                  style: kTextStyle(20),
                ),
                const Icon(
                  Icons.star,
                  size: 18,
                  color: Colors.amber,
                ),
              ],
            ),
            const SizedBox(
              width: 0.5,
              height: 20,
              child: ColoredBox(
                color: Colors.black,
              ),
            ),
            ref.watch(fetchListingsByAgentIDProvider(widget.id)).when(
                data: (listings) {
              return Text(
                "${listings.length} listing${listings.length == 1 ? '' : 's'}",
                style: kTextStyle(20),
              );
            }, error: (_, __) {
              return const Text("An error occured");
            }, loading: () {
              return const Text('......');
            }),
            const SizedBox(
              width: 0.5,
              height: 20,
              child: ColoredBox(
                color: Colors.black,
              ),
            ),
            Text(
              "${widget.user.reviews.length} review${widget.user.reviews.length == 1 ? '' : 's'}",
              style: kTextStyle(20),
            ),
          ],
        ),
        if (widget.user.reviews
            .where((review) =>
                review.userID ==
                ref.watch(firebaseAuthProvider).currentUser!.uid)
            .isEmpty)
          Column(
            children: [
              spaceY(40),
              Row(
                children: [
                  Text(
                    "Rate this agent",
                    style: kTextStyle(22, isBold: true),
                  ),
                ],
              ).padX(23),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < 5; i++)
                    IconButton(
                      onPressed: () => widget.onPressed(i),
                      icon: Icon(
                        Icons.star,
                        color: i < ref.watch(ratingProvider)
                            ? Colors.amber
                            : Colors.grey,
                        size: 35,
                      ),
                    )
                ],
              ).padX(10),
            ],
          ),
        spaceY(
          10,
        )
      ],
    );
  }
}

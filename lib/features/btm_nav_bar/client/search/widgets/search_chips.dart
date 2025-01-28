import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/enums.dart';
import 'package:home_quest/core/typedefs.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/btm_nav_bar/client/search/controller/search_filter_ctrl.dart';
import 'package:home_quest/shared/spacing.dart';

class CustomFilterChip extends ConsumerWidget {
  final Feature feature;
  final int selected;
  const CustomFilterChip({
    required this.feature,
    required this.selected,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          feature.name,
          style: kTextStyle(18, isBold: true),
        ),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 5,
          children: [
            ...List.generate(4, (index) => index).map(
              (no) => ChoiceChip(
                showCheckmark: false,
                padding: const EdgeInsets.all(12),
                label: Text(
                  no == 0
                      ? 'Any'
                      : no == 3
                          ? "$no+"
                          : '$no ',
                  style: kTextStyle(14),
                ),
                selected: switch (feature) {
                  Feature.bathrooms =>
                    no == ref.watch(searchFilterProvider).filter.bathrooms,
                  Feature.bedrooms =>
                    no == ref.watch(searchFilterProvider).filter.bedrooms,
                  Feature.kitchens =>
                    no == ref.watch(searchFilterProvider).filter.kitchens,
                  Feature.sitting_rooms =>
                    no == ref.watch(searchFilterProvider).filter.sittingRooms,
                },
                onSelected: (_) => {
                  switch (feature) {
                    Feature.bathrooms => ref
                        .read(searchFilterProvider.notifier)
                        .updateFilter(ref
                            .watch(searchFilterProvider)
                            .filter
                            .copyWith(bathrooms: no)),
                    Feature.bedrooms => ref
                        .read(searchFilterProvider.notifier)
                        .updateFilter(ref
                            .watch(searchFilterProvider)
                            .filter
                            .copyWith(bedrooms: no)),
                    Feature.kitchens => ref
                        .read(searchFilterProvider.notifier)
                        .updateFilter(ref
                            .watch(searchFilterProvider)
                            .filter
                            .copyWith(kitchens: no)),
                    Feature.sitting_rooms => ref
                        .read(searchFilterProvider.notifier)
                        .updateFilter(ref
                            .watch(searchFilterProvider)
                            .filter
                            .copyWith(sittingRooms: no)),
                  }
                },
              ),
            )
          ],
        ),
        spaceY(4)
      ],
    );
  }
}

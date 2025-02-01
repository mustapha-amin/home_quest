import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/colors.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/typedefs.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/controller/property_listing_ctrl.dart';
import 'package:home_quest/features/btm_nav_bar/client/search/controller/search_filter_ctrl.dart';
import 'package:home_quest/features/btm_nav_bar/client/search/widgets/search_chips.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:sizer/sizer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../../../core/enums.dart';
import '../../btm_nav_barC.dart';

InputDecoration kTextDecoration(String hint) => InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      hintText: hint,
    );

class SearchBottomSheet extends ConsumerStatefulWidget {
  const SearchBottomSheet({super.key});

  @override
  ConsumerState<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends ConsumerState<SearchBottomSheet> {
  List<String> lgas = [];
  int selectedRoom = 0;
  int selectedKitchen = 0;
  int selectedSittingRoom = 0;
  int selectedBathroom = 0;
  TextEditingController minPriceCtrl = TextEditingController();
  TextEditingController maxPriceCtrl = TextEditingController();
  TextEditingController minSizeCtrl = TextEditingController();
  TextEditingController maxSizeCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchfilter = ref.watch(searchFilterProvider);
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filledTonal(
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(8),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    ref.invalidate(currentScreenProvider);
                  },
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedCancel01,
                    color: Colors.black,
                    size: 18,
                  ),
                ).padX(5),
                Text(
                  "Filter",
                  style: kTextStyle(18, isBold: true),
                ),
                TextButton(
                  onPressed: () {
                    ref.invalidate(searchFilterProvider);
                  },
                  child: Text(
                    "Reset",
                    style: kTextStyle(15, color: AppColors.brown, isBold: true),
                  ),
                )
              ],
            ).padY(9),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 70.w,
                      child: SegmentedButton(
                        showSelectedIcon: false,
                        segments: [
                          ButtonSegment(
                            value: ListingType.rent,
                            label: Text(
                              ListingType.rent.name.captializeFirst,
                              style: kTextStyle(18, isBold: true),
                            ),
                          ),
                          ButtonSegment(
                            value: ListingType.sale,
                            label: Text(
                              ListingType.sale.name.captializeFirst,
                              style: kTextStyle(18, isBold: true),
                            ),
                          ),
                        ],
                        selected: ({searchfilter.filter.listingType}),
                        onSelectionChanged: (listing) {
                          PropertyFilter propertyFilter = searchfilter.filter
                              .copyWith(listingType: listing.first);
                          ref
                              .read(searchFilterProvider.notifier)
                              .updateFilter(propertyFilter);
                        },
                      ),
                    ).padY(5).centeralize(),
                    Text(
                      "Location",
                      style: kTextStyle(18, isBold: true),
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            dropdownStyleData:
                                const DropdownStyleData(elevation: 2),
                            buttonStyleData: ButtonStyleData(
                              height: 45,
                              width: 45.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            value: ref.watch(searchFilterProvider).filter.state,
                            hint: const Text("  Select state"),
                            items: [
                              ...NigerianStatesAndLGA.allStates.map(
                                (state) => DropdownMenuItem(
                                  value: state,
                                  child: Text(
                                    state,
                                    style: kTextStyle(15),
                                  ).padX(6),
                                ),
                              ),
                            ],
                            onChanged: (newVal) {
                              PropertyFilter propertyFilter =
                                  searchfilter.filter.copyWith(
                                      state: newVal,
                                      lga: NigerianStatesAndLGA.getStateLGAs(
                                          newVal!)[0]);
                              ref
                                  .read(searchFilterProvider.notifier)
                                  .updateFilter(propertyFilter);
                            },
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            dropdownStyleData:
                                const DropdownStyleData(elevation: 2),
                            buttonStyleData: ButtonStyleData(
                              height: 45,
                              width: 45.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            value: ref.watch(searchFilterProvider).filter.lga,
                            hint: const Text("  Select LGA"),
                            items:
                                ref.watch(searchFilterProvider).filter.state ==
                                        null
                                    ? []
                                    : [
                                        ...NigerianStatesAndLGA.getStateLGAs(ref
                                                .watch(searchFilterProvider)
                                                .filter
                                                .state!
                                                .captializeFirst)
                                            .map(
                                          (lga) => DropdownMenuItem(
                                            value: lga,
                                            child: Text(
                                              lga,
                                              style: kTextStyle(15),
                                            ).padX(6),
                                          ),
                                        ),
                                      ],
                            onChanged: (newVal) {
                              PropertyFilter propertyFilter =
                                  searchfilter.filter.copyWith(lga: newVal);
                              ref
                                  .read(searchFilterProvider.notifier)
                                  .updateFilter(propertyFilter);
                            },
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Condition",
                      style: kTextStyle(18, isBold: true),
                    ),
                    Wrap(
                      spacing: 5,
                      children: [
                        ...Condition.values.map(
                          (condition) => ChoiceChip(
                            label: Text(
                              condition.name.captializeFirst,
                              style: kTextStyle(15),
                            ),
                            selected:
                                searchfilter.filter.condition == condition,
                            onSelected: (_) {
                              PropertyFilter propertyFilter = searchfilter
                                  .filter
                                  .copyWith(condition: condition);
                              ref
                                  .read(searchFilterProvider.notifier)
                                  .updateFilter(propertyFilter);
                            },
                          ),
                        )
                      ],
                    ),
                    Text(
                      "Property type",
                      style: kTextStyle(18, isBold: true),
                    ),
                    Wrap(
                      spacing: 5,
                      children: [
                        ...PropertyType.values.map(
                          (type) => ChoiceChip(
                            label: Text(type.name.captializeFirst,
                                style: kTextStyle(15)),
                            selected: searchfilter.filter.propertyType == type,
                            onSelected: (_) {
                              PropertyFilter propertyFilter = searchfilter
                                  .filter
                                  .copyWith(propertyType: type);
                              ref
                                  .read(searchFilterProvider.notifier)
                                  .updateFilter(propertyFilter);
                            },
                          ),
                        )
                      ],
                    ),
                    Text(
                      "Property subtype",
                      style: kTextStyle(18, isBold: true),
                    ),
                    Wrap(
                      spacing: 5,
                      children: [
                        ...PropertySubtype.values.map(
                          (subtype) => ChoiceChip(
                            label: Text(subtype.name.captializeFirst,
                                style: kTextStyle(15)),
                            selected:
                                searchfilter.filter.propertySubtype == subtype,
                            onSelected: (_) {
                              PropertyFilter propertyFilter = searchfilter
                                  .filter
                                  .copyWith(propertySubtype: subtype);
                              ref
                                  .read(searchFilterProvider.notifier)
                                  .updateFilter(propertyFilter);
                            },
                          ),
                        )
                      ],
                    ),
                    Text("Price", style: kTextStyle(18, isBold: true)),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                            child: TextField(
                          controller: minPriceCtrl,
                          decoration: kTextDecoration("Min"),
                          keyboardType: TextInputType.number,
                          inputFormatters: [ThousandsFormatter()],
                          onChanged: (value) {
                            final filter = searchfilter.filter.copyWith(
                                minPrice: double.parse(minPriceCtrl.text
                                    .split(',')
                                    .join('')
                                    .trim()));
                            ref
                                .read(searchFilterProvider.notifier)
                                .updateFilter(filter);
                          },
                        )),
                        Text('-'),
                        Expanded(
                            child: TextField(
                          controller: maxPriceCtrl,
                          decoration: kTextDecoration("Max"),
                          keyboardType: TextInputType.number,
                          inputFormatters: [ThousandsFormatter()],
                          onChanged: (value) {
                            final filter = searchfilter.filter.copyWith(
                                maxPrice: double.parse(maxPriceCtrl.text
                                    .split(',')
                                    .join('')
                                    .trim()));
                            ref
                                .read(searchFilterProvider.notifier)
                                .updateFilter(filter);
                          },
                        )),
                      ],
                    ),
                    Text(
                      "Property Size",
                      style: kTextStyle(18, isBold: true),
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                            child: TextField(
                          controller: minSizeCtrl,
                          decoration: kTextDecoration("Min"),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final filter = searchfilter.filter.copyWith(
                                minPropertySize:
                                    double.parse(minSizeCtrl.text.trim()));
                            ref
                                .read(searchFilterProvider.notifier)
                                .updateFilter(filter);
                          },
                        )),
                        Text('-'),
                        Expanded(
                            child: TextField(
                          controller: maxSizeCtrl,
                          decoration: kTextDecoration("Max"),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final filter = searchfilter.filter.copyWith(
                                maxPropertySize:
                                    double.parse(maxSizeCtrl.text.trim()));
                            ref
                                .read(searchFilterProvider.notifier)
                                .updateFilter(filter);
                          },
                        )),
                      ],
                    ),
                    CustomFilterChip(
                        feature: Feature.bedrooms, selected: selectedRoom),
                    CustomFilterChip(
                        feature: Feature.bathrooms, selected: selectedBathroom),
                    CustomFilterChip(
                        feature: Feature.kitchens, selected: selectedKitchen),
                    CustomFilterChip(
                        feature: Feature.sitting_rooms,
                        selected: selectedSittingRoom),
                  ],
                ),
              ).padX(12).padY(9),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12, right: 8, left: 8),
              child: SizedBox(
                height: 50,
                width: 100.w,
                child: FilledButton(
                  onPressed: () {
                    log(ref.watch(searchFilterProvider).filter.toString());
                    ref.read(searchFilterProvider.notifier).updateFilter(
                        ref.watch(searchFilterProvider).filter,
                        searching: true);
                    Navigator.of(context).pop();
                    ref.read(fetchListingsWithFiltersProvider(
                      ref.watch(searchFilterProvider).filter,
                    ));
                  },
                  child: Text(
                    "Search",
                    style: kTextStyle(16, color: Colors.white, isBold: true),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

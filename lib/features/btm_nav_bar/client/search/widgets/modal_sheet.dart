import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/colors.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/typedefs.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/btm_nav_bar/client/search/controller/search_filter_ctrl.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:sizer/sizer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../../../core/enums.dart';

InputDecoration kTextDecoration(String hint) => InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      hintText: hint,
    );

class AppBottomSheet extends ConsumerStatefulWidget {
  const AppBottomSheet({super.key});

  @override
  ConsumerState<AppBottomSheet> createState() => _AppBottomSheetState();
}

class _AppBottomSheetState extends ConsumerState<AppBottomSheet> {
  List<int> noOfSmtn = List.generate(4, (index) => index);
  List<String> lgas = [];

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
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(8),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  label: const HugeIcon(
                    icon: HugeIcons.strokeRoundedCancel01,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
                Text(
                  "Search",
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
                        selectedIcon: const HugeIcon(
                          icon: HugeIcons.strokeRoundedTick01,
                          color: AppColors.brown,
                        ),
                        segments: [
                          ButtonSegment(
                            value: ListingType.rent,
                            label: Text(
                              ListingType.rent.name.captializeFirst,
                              style: kTextStyle(15, isBold: true),
                            ),
                          ),
                          ButtonSegment(
                            value: ListingType.sale,
                            label: Text(
                              ListingType.sale.name.captializeFirst,
                              style: kTextStyle(15, isBold: true),
                            ),
                          ),
                        ],
                        selected: ({searchfilter.listingType}),
                        onSelectionChanged: (listing) {
                          PropertyFilter propertyFilter =
                              searchfilter.copyWith(listingType: listing.first);
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
                            value: ref.watch(searchFilterProvider).state,
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
                                  searchfilter.copyWith(
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
                            value: ref.watch(searchFilterProvider).lga,
                            hint: const Text("  Select LGA"),
                            items: ref.watch(searchFilterProvider).state == null
                                ? []
                                : [
                                    ...NigerianStatesAndLGA.getStateLGAs(ref
                                            .watch(searchFilterProvider)
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
                                  searchfilter.copyWith(lga: newVal);
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
                            selected: searchfilter.condition == condition,
                            onSelected: (_) {
                              PropertyFilter propertyFilter =
                                  searchfilter.copyWith(condition: condition);
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
                            selected: searchfilter.propertyType == type,
                            onSelected: (_) {
                              PropertyFilter propertyFilter =
                                  searchfilter.copyWith(propertyType: type);
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
                            selected: searchfilter.propertySubtype == subtype,
                            onSelected: (_) {
                              PropertyFilter propertyFilter = searchfilter
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
                          decoration: kTextDecoration("Min"),
                          keyboardType: TextInputType.number,
                          inputFormatters: [ThousandsFormatter()],
                        )),
                        Expanded(
                            child: TextField(
                          decoration: kTextDecoration("Max"),
                          keyboardType: TextInputType.number,
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
                          decoration: kTextDecoration("Min"),
                          keyboardType: TextInputType.number,
                        )),
                        Expanded(
                            child: TextField(
                          decoration: kTextDecoration("Max"),
                          keyboardType: TextInputType.number,
                        )),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Rooms",
                                style: kTextStyle(18, isBold: true),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2<int>(
                                  dropdownStyleData:
                                      const DropdownStyleData(elevation: 2),
                                  buttonStyleData: ButtonStyleData(
                                    height: 45,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  value:
                                      ref.watch(searchFilterProvider).bedrooms,
                                  items: [
                                    ...noOfSmtn.map(
                                      (no) => DropdownMenuItem(
                                        value: no,
                                        child: Text(
                                          no < 3 ? no.toString() : '$no+',
                                          style: kTextStyle(15),
                                        ).padX(6),
                                      ),
                                    ),
                                  ],
                                  onChanged: (newVal) {
                                    PropertyFilter propertyFilter =
                                        searchfilter.copyWith(bedrooms: newVal);
                                    ref
                                        .read(searchFilterProvider.notifier)
                                        .updateFilter(propertyFilter);
                                    log(ref
                                        .watch(searchFilterProvider)
                                        .toString());
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kitchens",
                                style: kTextStyle(18, isBold: true),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2<int>(
                                  dropdownStyleData:
                                      const DropdownStyleData(elevation: 2),
                                  buttonStyleData: ButtonStyleData(
                                    height: 45,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  value:
                                      ref.watch(searchFilterProvider).kitchens,
                                  items: [
                                    ...noOfSmtn.map(
                                      (no) => DropdownMenuItem(
                                        value: no,
                                        child: Text(
                                          no < 3 ? no.toString() : '$no+',
                                          style: kTextStyle(15),
                                        ).padX(6),
                                      ),
                                    ),
                                  ],
                                  onChanged: (newVal) {
                                    PropertyFilter propertyFilter =
                                        searchfilter.copyWith(kitchens: newVal);
                                    ref
                                        .read(searchFilterProvider.notifier)
                                        .updateFilter(propertyFilter);
                                    log(ref
                                        .watch(searchFilterProvider)
                                        .toString());
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sitting rooms",
                                style: kTextStyle(18, isBold: true),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2<int>(
                                  dropdownStyleData:
                                      const DropdownStyleData(elevation: 2),
                                  buttonStyleData: ButtonStyleData(
                                    height: 45,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  value: ref
                                      .watch(searchFilterProvider)
                                      .sittingRooms,
                                  items: [
                                    ...noOfSmtn.map(
                                      (no) => DropdownMenuItem(
                                        value: no,
                                        child: Text(
                                          no < 3 ? no.toString() : '$no+',
                                          style: kTextStyle(15),
                                        ).padX(6),
                                      ),
                                    ),
                                  ],
                                  onChanged: (newVal) {
                                    PropertyFilter propertyFilter = searchfilter
                                        .copyWith(sittingRooms: newVal);
                                    ref
                                        .read(searchFilterProvider.notifier)
                                        .updateFilter(propertyFilter);
                                    log(ref
                                        .watch(searchFilterProvider)
                                        .toString());
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bathrooms",
                                style: kTextStyle(18, isBold: true),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2<int>(
                                  dropdownStyleData:
                                      const DropdownStyleData(elevation: 2),
                                  buttonStyleData: ButtonStyleData(
                                    height: 45,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  value:
                                      ref.watch(searchFilterProvider).bathrooms,
                                  items: [
                                    ...noOfSmtn.map(
                                      (no) => DropdownMenuItem(
                                        value: no,
                                        child: Text(
                                          no < 3 ? no.toString() : '$no+',
                                          style: kTextStyle(15),
                                        ).padX(6),
                                      ),
                                    ),
                                  ],
                                  onChanged: (newVal) {
                                    PropertyFilter propertyFilter = searchfilter
                                        .copyWith(bathrooms: newVal);
                                    ref
                                        .read(searchFilterProvider.notifier)
                                        .updateFilter(propertyFilter);
                                    log(ref
                                        .watch(searchFilterProvider)
                                        .toString());
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).padX(12).padY(9),
            ),
            Row(
              spacing: 5,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: Text(
                        "Cancel",
                        style: kTextStyle(16,
                            color: AppColors.brown, isBold: true),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: FilledButton(
                      onPressed: () {},
                      child: Text(
                        "Search",
                        style:
                            kTextStyle(16, color: Colors.white, isBold: true),
                      ),
                    ),
                  ),
                )
              ],
            ).padX(12).padY(5)
          ],
        ),
      ],
    );
  }
}

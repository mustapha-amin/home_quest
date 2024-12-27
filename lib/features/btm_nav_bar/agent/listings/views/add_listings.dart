import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/colors.dart';
import 'package:home_quest/core/enums.dart';
import 'package:home_quest/core/extensions/navigations.dart';
import 'package:home_quest/core/extensions/widget_exts.dart';
import 'package:home_quest/core/utils/image_picker_util.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/views/select_location.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/widgets/images_list_view.dart';
import 'package:home_quest/models/listing_feature.dart';
import 'package:home_quest/models/property_listing.dart';
import 'package:home_quest/shared/custom_button.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:uuid/uuid.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import '../widgets/pictures_text_header.dart';

final pickedImagesCtrl = AutoDisposeStateProvider<List<File>>((ref) {
  return [];
});

final selectedLocationProvider = StateProvider<String?>((ref) {
  return null;
});

InputDecoration _textDecoration({
  String? hintText,
  String? prefix,
  Widget? suffix,
}) {
  return InputDecoration(
    labelText: hintText,
    prefixText: prefix,
    suffixIcon: suffix,
    contentPadding: const EdgeInsets.all(18),
    border: const OutlineInputBorder(),
  );
}

class AddListings extends ConsumerStatefulWidget {
  const AddListings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddListingsState();
}

// TODO: select location, address, property siz
class _AddListingsState extends ConsumerState<AddListings> {
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController propertySizeCtrl = TextEditingController();
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController agentFeeCtrl = TextEditingController();
  String? selectedState;
  String? selectedLGA;
  List<String> allLGAs = [];
  PropertyType propertyType = PropertyType.apartment;
  Condition condition = Condition.old;
  PropertySubtype propertySubtype = PropertySubtype.detached;
  Furnishing furnishing = Furnishing.unfurnished;
  ListingType listingType = ListingType.rent;
  List<Facility>? selectedFacilities = [];
  List<ListingFeature> listingFeatures = [];
  List<TextEditingController> textControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          "List a property",
          style: kTextStyle(20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PicturesTextHeader(),
                  SizedBox(
                    height: 80,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: IconButton.filledTonal(
                            style: IconButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              final imagesNames = ref
                                  .watch(pickedImagesCtrl)
                                  .map((image) => image.path.split('/').last);
                              List<File> images = ref.read(pickedImagesCtrl);
                              final result = await pickImages();
                              result.fold(
                                (l) => log(l),
                                (r) {
                                  for (final image in r) {
                                    if (!imagesNames.contains(
                                            image!.path.split('/').last) &&
                                        ref.watch(pickedImagesCtrl).length <
                                            10) {
                                      images.add(image);
                                    }
                                  }
                                  images = images.take(10).toList();
                                  ref.read(pickedImagesCtrl.notifier).state =
                                      images;
                                },
                              );
                            },
                            icon: const HugeIcon(
                              icon: HugeIcons.strokeRoundedAdd01,
                              color: AppColors.brown,
                            ),
                          ),
                        ),
                        ImagesListView(
                          images: ref.watch(pickedImagesCtrl),
                          onCancel: (index) {
                            ref.read(pickedImagesCtrl.notifier).state = ref
                                .watch(pickedImagesCtrl)
                                .where((file) =>
                                    ref.watch(pickedImagesCtrl).indexOf(file) !=
                                    index)
                                .toList();
                          },
                        )
                      ],
                    ),
                  ).padY(10),
                  Text(
                    "Images count: ${ref.watch(pickedImagesCtrl).length}",
                    style: kTextStyle(15),
                  ),
                  spaceY(5),
                  Text(
                    "Location",
                    style: kTextStyle(18, isBold: true),
                  ),
  
                  spaceY(8),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          context.push(const SelectLocation());
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Row(
                          children: [
                            Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: const Color(0xFFFFADDBB)),
                                child: const HugeIcon(
                                  icon: HugeIcons.strokeRoundedLocation01,
                                  size: 18,
                                  color: Colors.black,
                                )),
                            spaceX(6),
                            Text(
                              "Pick location",
                              style: kTextStyle(15),
                            ),
                          ],
                        ).padAll(7),
                      ),
                    ],
                  ),
                  spaceY(8),
                  TextField(
                    controller: addressCtrl,
                    decoration: _textDecoration(hintText: "Address"),
                  ),

                  spaceY(8),
                  TextField(
                    controller: propertySizeCtrl,
                    keyboardType: const TextInputType.numberWithOptions(),
                    decoration:
                        _textDecoration(hintText: "Property size (sqm)"),
                  ),
                  Text(
                    "Select all that apply",
                    style: kTextStyle(18, isBold: true),
                  ).padY(15),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 5,
                              children: [
                                ...PropertyType.values.map(
                                  (type) => ChoiceChip(
                                    label: Text(type.name),
                                    selected: propertyType == type,
                                    onSelected: (_) {
                                      setState(() {
                                        propertyType = type;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Wrap(spacing: 5, children: [
                              ...PropertySubtype.values.map(
                                (type) => ChoiceChip(
                                  label: Text(type.name),
                                  selected: propertySubtype == type,
                                  onSelected: (selected) {
                                    setState(() {
                                      propertySubtype = type;
                                    });
                                  },
                                ),
                              )
                            ]),
                            Wrap(
                              spacing: 5,
                              children: [
                                ...Condition.values.map(
                                  (type) => ChoiceChip(
                                    label: Text(type.name),
                                    selected: condition == type,
                                    onSelected: (selected) {
                                      setState(() {
                                        condition = type;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 5,
                              children: [
                                ...Furnishing.values.map(
                                  (type) => ChoiceChip(
                                    label: Text(type.name),
                                    selected: furnishing == type,
                                    onSelected: (selected) {
                                      setState(() {
                                        furnishing = type;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 5,
                              children: [
                                ...ListingType.values.map(
                                  (type) => ChoiceChip(
                                    label: Text(type.name),
                                    selected: listingType == type,
                                    onSelected: (selected) {
                                      setState(() {
                                        listingType = type;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ).padX(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...Facility.values
                                    .where((facility) =>
                                        Facility.values.indexOf(facility) < 4)
                                    .map(
                                      (facility) => Row(
                                        children: [
                                          Checkbox(
                                            value: selectedFacilities!
                                                .contains(facility),
                                            onChanged: (_) {
                                              setState(() {
                                                if (selectedFacilities!
                                                    .contains(facility)) {
                                                  selectedFacilities!
                                                      .remove(facility);
                                                } else {
                                                  selectedFacilities!
                                                      .add(facility);
                                                }
                                              });
                                            },
                                          ),
                                          Text(facility.name),
                                        ],
                                      ),
                                    ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...Facility.values
                                    .where((facility) =>
                                        Facility.values.indexOf(facility) >= 4)
                                    .map(
                                      (facility) => Row(
                                        children: [
                                          Checkbox(
                                            value: selectedFacilities!
                                                .contains(facility),
                                            onChanged: (_) {
                                              setState(() {
                                                if (selectedFacilities!
                                                    .contains(facility)) {
                                                  selectedFacilities!
                                                      .remove(facility);
                                                } else {
                                                  selectedFacilities!
                                                      .add(facility);
                                                }
                                              });
                                            },
                                          ),
                                          Text(facility.name),
                                        ],
                                      ),
                                    ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ...Feature.values.map((feature) => TextFormField(
                        controller:
                            textControllers[Feature.values.indexOf(feature)],
                        decoration: _textDecoration(
                          hintText: "No. of ${feature.name}",
                        ),
                        keyboardType: const TextInputType.numberWithOptions(),
                        validator: (text) {
                          if (int.parse(text!).runtimeType != int) {
                            return "Must be an integer";
                          } else if (int.parse(text) < 0) {
                            "Can't be less than 0";
                          }

                          return null;
                        },
                      ).padY(10)),
                  Text(
                    "Payment",
                    style: kTextStyle(18, isBold: true),
                  ).padY(15),
                  TextField(
                    controller: priceCtrl,
                    keyboardType: const TextInputType.numberWithOptions(),
                    decoration:
                        _textDecoration(hintText: "Price", prefix: '\u20A6 '),
                    inputFormatters: [
                      ThousandsFormatter(allowFraction: true),
                    ],
                  ),
                  spaceY(8),
                  TextField(
                    keyboardType: const TextInputType.numberWithOptions(),
                    controller: agentFeeCtrl,
                    decoration: _textDecoration(
                        hintText: "Agent fee", prefix: '\u20A6 '),
                    inputFormatters: [
                      ThousandsFormatter(allowFraction: true),
                    ],
                  ),
                  spaceY(8),
                ],
              ).padAll(20),
            ),
          ),
          CustomButton(
            label: "List property",
            onTap: () {
              final propertyListing = PropertyListing(
                id: const Uuid().v4(),
                agentID: 'agentID',
                address: addressCtrl.text.trim(),
                propertyType: propertyType,
                propertySize: double.parse(propertySizeCtrl.text),
                price: double.parse(propertySizeCtrl.text),
                agentFee: double.parse(agentFeeCtrl.text),
                listingType: listingType,
                imagesUrls: ref
                    .watch(pickedImagesCtrl.notifier)
                    .state
                    .map((image) => image.path)
                    .toList(),
                features: listingFeatures,
                condition: condition,
                facilities: selectedFacilities!,
                furnishing: furnishing,
                propertySubtype: propertySubtype,
              );
              print(propertyListing);
            },
          ).padAll(8),
        ],
      ),
    );
  }
}

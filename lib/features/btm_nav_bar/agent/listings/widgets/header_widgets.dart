import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/providers.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/colors.dart';
import '../../../../../core/utils/textstyle.dart';
import '../../../../../models/geolocation.dart';
import '../../../../../services/geocoding_service.dart';

final isExpanded = StateProvider.autoDispose((ref) {
  return false;
});

final geolocationNotifierProvider =
    StateNotifierProvider<GeoLocationNotifier, (GeoLocation?, bool)>((ref) {
  return GeoLocationNotifier();
});

class GeoLocationNotifier extends StateNotifier< (GeoLocation?, bool)> {
  GeoLocationNotifier() : super((null, false));

  Future<void> forwardCoding(BuildContext context, String query) async {
    state = (null, true);
    try {
      final location = await GeocodingService.forwardCoding(query);
      log(location.toString());
      state = (location, false);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      state = (state.$1, false);
    }
  }

  Future<void> reverseCoding(BuildContext context, LatLng latlng) async {
    state = (null, true);
    try {
      final location = await GeocodingService.reverseCoding(latlng);
      log(location.toString());
      state = (location, false);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      state = (state.$1, false);
    }
  }

  void updateLocation(GeoLocation geoLoc) {
    state = (geoLoc, false);
  }
}

class HeaderWidgets extends ConsumerWidget {
  final VoidCallback onSave;
  final void Function(GeoLocation? geoLocation) onSearch;
  final TextEditingController searchCtrl;
  final FocusNode focusNode;
  const HeaderWidgets({
    required this.onSave,
    required this.searchCtrl,
    required this.focusNode,
    required this.onSearch,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(geolocationNotifierProvider, (prev, next) {
      if (prev != next) {
        ref
            .read(globalLoadingProvider.notifier)
            .toggleGlobalLoadingIndicator(next.$2);
      }
    });
    return Positioned(
      top: 70,
      left: 5,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.7),
            ),
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              color: Colors.black,
            ),
            iconSize: 28,
            onPressed: () {
              ref.watch(isExpanded)
                  ? {
                      focusNode.unfocus(),
                      ref.read(isExpanded.notifier).state = false
                    }
                  : Navigator.of(context).pop();
            },
          ),
          Expanded(
            child: AnimatedCrossFade(
              firstChild: SearchBar(
                controller: searchCtrl,
                focusNode: focusNode,
                elevation: const WidgetStatePropertyAll(0),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                hintText: 'e.g  Rijiyar Zaki, Kano',
                textInputAction: TextInputAction.search,
                onSubmitted: (value) async {
                  if (value.isNotEmpty) {
                    await ref
                        .read(geolocationNotifierProvider.notifier)
                        .forwardCoding(context, value);
                    ref.read(isExpanded.notifier).state = false;
                    if (ref.watch(geolocationNotifierProvider).$1 != null) {
                      onSearch(ref.watch(geolocationNotifierProvider).$1);
                    }
                  }
                },
                hintStyle: WidgetStatePropertyAll(
                  kTextStyle(15, color: Colors.grey),
                ),
                textStyle: WidgetStatePropertyAll(
                  kTextStyle(15, color: Colors.black),
                ),
                trailing: [
                  InkWell(
                    onTap: () {
                      ref.read(isExpanded.notifier).state = false;
                      searchCtrl.clear();
                    },
                    child: const HugeIcon(
                      icon: HugeIcons.strokeRoundedCancel01,
                      color: AppColors.brown,
                      size: 28,
                    ),
                  )
                ],
              ).padX(8),
              secondChild: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton.filledTonal(
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFF3E7DB),
                    ),
                    onPressed: () {
                      ref.read(isExpanded.notifier).state = true;
                      Future.delayed(const Duration(milliseconds: 10),
                          () => focusNode.requestFocus());
                    },
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedSearch01,
                      color: Color.fromARGB(255, 4, 4, 3),
                      size: 28,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brown,
                    ),
                    onPressed: onSave,
                    child: Text(
                      "Save",
                      style: kTextStyle(15, color: Colors.white),
                    ),
                  )
                ],
              ),
              crossFadeState: ref.watch(isExpanded)
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
              firstCurve: Curves.easeInOut,
              secondCurve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }
}

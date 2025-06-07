import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:home_quest/core/extensions.dart';

import 'package:home_quest/core/providers.dart';
import 'package:home_quest/core/utils/nigeria_bound_extracter.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/widgets/header_widgets.dart';
import 'package:home_quest/shared/loading_indicator.dart';

import '../../../../../core/colors.dart';
import '../widgets/mapping_hint_widget.dart';

final mapIsMovingProvider = StateProvider.autoDispose((ref) {
  return false;
});

class SelectLocation extends ConsumerStatefulWidget {
  const SelectLocation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectLocationState();
}

class _SelectLocationState extends ConsumerState<SelectLocation> {
  final SearchController searchController = SearchController();
  FocusNode focusNode = FocusNode();
  LatLng? currentPosition;
  late List<LatLng> nigerianBorder;
  bool borderLoaded = false;

  void initBounds() async {
   nigerianBorder = await loadNigeriaBorder();
    setState(() {
      borderLoaded = true;
    });
  }

  @override
  void initState() {
    initBounds();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          ref.watch(userLocationProvider).when(
            data: (data) {
              currentPosition = LatLng(data.latitude, data.longitude);
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: currentPosition!,
                      zoom: 12,
                    ),
                    polylines: {
                      Polyline(
                        polylineId: PolylineId('nigeria'),
                        points: borderLoaded ? nigerianBorder : [currentPosition!],
                        color: Colors.red,
                      ),
                    },
                  ),
                  Consumer(builder: (context, ref, _) {
                    bool mapIsMoving = ref.watch(mapIsMovingProvider);
                    return !mapIsMoving
                        ? const Positioned(
                            bottom: 20,
                            child: MappingHintWidget(),
                          )
                        : const SizedBox();
                  }),
                ],
              );
            },
            error: (e, stk) {
              log('${e.toString()}', stackTrace: stk);

              return Center(
                child: Text("Error fetching location. Check your internet"),
              );
            },
            loading: () {
              return const Center(
                child: SpinKitWaveSpinner(
                  color: AppColors.brown,
                  size: 80,
                ),
              );
            },
          ),
          if (ref.watch(isLoadingProvider)) const LoadingIndicator(),
          HeaderWidgets(
            searchCtrl: searchController,
            focusNode: focusNode,
            onSave: () async {
              // await ref
              //     .read(geolocationNotifierProvider.notifier)
              //     .reverseCoding(context, mapController.camera.center);
              // ref
              //     .read(globalLoadingProvider.notifier)
              //     .toggleGlobalLoadingIndicator(true);
              if (ref.watch(geolocationNotifierProvider).$1 != null) {
                context.pop();
              }
              ref
                  .read(globalLoadingProvider.notifier)
                  .toggleGlobalLoadingIndicator(false);
            },
            onSearch: (location) {
              //mapController.move(LatLng(location!.lat!, location.lng!), 13);
              // locationMarkerPosStream.sink.add(
              //   LocationMarkerPosition(
              //     latitude: location.lat!,
              //     longitude: location.lng!,
              //     accuracy: 1,
              //   ),
              // );
            },
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          heroTag: 'btn2',
          tooltip: 'My Location',
          elevation: 0,
          onPressed: () {
            // locationMarkerPosStream.sink.add(
            //   LocationMarkerPosition(
            //     latitude: currentPosition!.latitude,
            //     longitude: currentPosition!.longitude,
            //     accuracy: 1,
            //   ),
            // );
            // mapController.move(currentPosition!, mapController.camera.zoom);
          },
          child: const Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.location_searching_outlined,
                color: AppColors.brown,
                size: 35,
              ),
              Icon(
                Icons.question_mark,
                color: AppColors.brown,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

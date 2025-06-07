import 'dart:developer';

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
  LatLng? currentUserPosition;
  LatLng? newUserPosition;
  late List<LatLng> nigerianBorder;
  bool borderLoaded = false;
  late GoogleMapController googleMapController;
  bool isMapReady = false;

  // void initBounds() async {
  //   nigerianBorder = await loadNigeriaBorder();
  //   setState(() {
  //     borderLoaded = true;
  //   });
  // }

  // @override
  // void initState() {
  //   initBounds();
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            ref.watch(userLocationProvider).when(
              data: (data) {
                currentUserPosition ??= LatLng(data.latitude, data.longitude);
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: GoogleMap(
                        onMapCreated: (controller) {
                          googleMapController = controller;
                          setState(() {
                            isMapReady = true; // Mark map as ready
                          });
                        },
                        onTap: !isMapReady
                            ? null
                            : (newPosition) {
                                log(newPosition.toString());
                                setState(() {
                                  newUserPosition = newPosition;
                                });
                              },
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: currentUserPosition!,
                          zoom: 16,
                        ),
                        markers: {
                          Marker(
                              markerId: const MarkerId('Your location'),
                              position: newUserPosition ?? currentUserPosition!)
                        },
                        mapType: MapType.hybrid,
                        polylines: {
                          Polyline(
                            polylineId: const PolylineId('nigeria'),
                            points: borderLoaded
                                ? nigerianBorder
                                : [currentUserPosition!],
                            color: Colors.red,
                          ),
                        },
                      ),
                    ),
                    const Positioned(
                      bottom: 20,
                      child: MappingHintWidget(),
                    )
                  ],
                );
              },
              error: (e, stk) {
                log(e.toString(), stackTrace: stk);
                return const Center(
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
            Positioned(
              top: 0,
              left: 0,
              child: HeaderWidgets(
                searchCtrl: searchController,
                focusNode: focusNode,
                onSave: () async {
                  await ref
                      .read(geolocationNotifierProvider.notifier)
                      .reverseCoding(
                          context, newUserPosition ?? currentUserPosition!);
                  ref
                      .read(globalLoadingProvider.notifier)
                      .toggleGlobalLoadingIndicator(true);
                  if (ref.watch(geolocationNotifierProvider).$1 != null) {
                    context.pop();
                  }
                  ref
                      .read(globalLoadingProvider.notifier)
                      .toggleGlobalLoadingIndicator(false);
                },
                onSearch: (location) async {
                  await googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        zoom: 16,
                        target: LatLng(location!.lat!, location.lng!),
                      ),
                    ),
                  );
                  setState(() {
                    newUserPosition = LatLng(location.lat!, location.lng!);
                  });
                },
              ),
            ),
          ],
        ),
        // floatingActionButton: SizedBox(
        //   width: 70,
        //   height: 70,
        //   child: FloatingActionButton(
        //     heroTag: 'btn2',
        //     tooltip: 'My Location',
        //     elevation: 0,
        //     onPressed: () {
        //       // locationMarkerPosStream.sink.add(
        //       //   LocationMarkerPosition(
        //       //     latitude: currentPosition!.latitude,
        //       //     longitude: currentPosition!.longitude,
        //       //     accuracy: 1,
        //       //   ),
        //       // );
        //       // mapController.move(currentPosition!, mapController.camera.zoom);
        //     },
        //     child: const Stack(
        //       alignment: Alignment.center,
        //       children: [
        //         Icon(
        //           Icons.location_searching_outlined,
        //           color: AppColors.brown,
        //           size: 35,
        //         ),
        //         Icon(
        //           Icons.question_mark,
        //           color: AppColors.brown,
        //           size: 15,
        //         ),
        //       ],
        //     ),
        //   ),
      ),
    );
  }
}

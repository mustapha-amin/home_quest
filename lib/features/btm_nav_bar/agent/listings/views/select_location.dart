import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_quest/core/extensions.dart';

import 'package:home_quest/core/providers.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/widgets/header_widgets.dart';
import 'package:home_quest/shared/loading_indicator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/colors.dart';
import '../../../../../core/coords.dart';
import '../widgets/mapping_hint_widget.dart';
import 'package:geolocator/geolocator.dart';

final userLocationProvider = FutureProvider((ref) async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 
  return await Geolocator.getCurrentPosition();
});

final mapIsMovingProvider = StateProvider.autoDispose((ref) {
  return false;
});

class SelectLocation extends ConsumerStatefulWidget {
  const SelectLocation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectLocationState();
}

class _SelectLocationState extends ConsumerState<SelectLocation> {
  final MapController mapController = MapController();
  final SearchController searchController = SearchController();
  FocusNode focusNode = FocusNode();
  LatLng? currentPosition;
  StreamController<LocationMarkerPosition> locationMarkerPosStream =
      StreamController();
  List<List<LatLng>> nigerianMapBounds = [];
  LatLngBounds? nigeriaBounds;

  List<List<LatLng>> extractCoordinates(Map<String, dynamic> geojsonData) {
    final coordinates =
        geojsonData['features'][0]['geometry']['coordinates'] as List;
    List<List<LatLng>> polygons = coordinates.map<List<LatLng>>((polygon) {
      final ring = polygon[0] as List;
      return ring.map<LatLng>((coord) {
        return LatLng(coord[1], coord[0]);
      }).toList();
    }).toList();
    return polygons;
  }

  void initBoundaries() {
    nigerianMapBounds = extractCoordinates(NigeriaBoundaries.coords);
    nigeriaBounds = LatLngBounds.fromPoints(
      nigerianMapBounds.map((e) => e).expand((e) => e).toList(),
    );
  }

  @override
  void initState() {
    initBoundaries();
    super.initState();
  }

  @override
  void dispose() {
    locationMarkerPosStream.close();
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
              currentPosition = LatLng(data.latitude!, data.longitude!);
              locationMarkerPosStream.sink.add(
                LocationMarkerPosition(
                  latitude: currentPosition!.latitude,
                  longitude: currentPosition!.longitude,
                  accuracy: 1,
                ),
              );
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                        initialCenter: currentPosition!,
                        initialZoom: 9,
                        minZoom: 6,
                        cameraConstraint: CameraConstraint.containCenter(
                            bounds: nigeriaBounds!),
                        onPositionChanged: (camera, moving) {
                          locationMarkerPosStream.sink.add(
                            LocationMarkerPosition(
                              latitude: camera.center.latitude,
                              longitude: camera.center.longitude,
                              accuracy: 1,
                            ),
                          );
                        },
                        onMapEvent: (event) {
                          if (event.source == MapEventSource.onDrag) {
                            ref.read(mapIsMovingProvider.notifier).state = true;
                            log("moving");
                          } else if (event.source == MapEventSource.dragEnd) {
                            ref.read(mapIsMovingProvider.notifier).state =
                                false;
                            log("stopped");
                          }
                        }),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://api.mapbox.com/styles/v1/mustyameen/cm4tu2iyy002r01s18ylrerzd/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibXVzdHlhbWVlbiIsImEiOiJjbTRucTJjNmIwYjJsMmpxc3R5bGEwcm1mIn0.O8Jpsml14mA7jpVLFvmcbg',
                        userAgentPackageName: 'com.mustapha.homequest',
                        additionalOptions: const {
                          "accessToken":
                              "pk.eyJ1IjoibXVzdHlhbWVlbiIsImEiOiJjbTRucTJjNmIwYjJsMmpxc3R5bGEwcm1mIn0.O8Jpsml14mA7jpVLFvmcbg",
                          "id":
                              "mapbox://styles/mustyameen/cm4tu2iyy002r01s18ylrerzd"
                        },
                      ),
                      PolygonLayer(
                        polygons: [
                          ...nigerianMapBounds.map(
                            (points) => Polygon(
                              points: points,
                              borderColor: Colors.green,
                              borderStrokeWidth: 6.0,
                              color: Colors.green.withOpacity(0.1),
                            ),
                          )
                        ],
                      ),
                      StreamBuilder(
                        stream: locationMarkerPosStream.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return LocationMarkerLayer(
                              position: snapshot.data!,
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ],
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
              await ref
                  .read(geolocationNotifierProvider.notifier)
                  .reverseCoding(context, mapController.camera.center);
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
            onSearch: (location) {
              mapController.move(LatLng(location!.lat!, location.lng!), 13);
              locationMarkerPosStream.sink.add(
                LocationMarkerPosition(
                  latitude: location.lat!,
                  longitude: location.lng!,
                  accuracy: 1,
                ),
              );
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
            locationMarkerPosStream.sink.add(
              LocationMarkerPosition(
                latitude: currentPosition!.latitude,
                longitude: currentPosition!.longitude,
                accuracy: 1,
              ),
            );
            mapController.move(currentPosition!, mapController.camera.zoom);
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

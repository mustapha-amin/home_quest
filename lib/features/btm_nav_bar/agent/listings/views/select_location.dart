import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_quest/core/extensions/widget_exts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import '../../../../../core/colors.dart';
import '../../../../../core/coords.dart';
import '../../../../../core/utils/textstyle.dart';

final userLocationProvider = FutureProvider((ref) async {
  return await Location.instance.getLocation();
});

class SelectLocation extends ConsumerStatefulWidget {
  const SelectLocation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectLocationState();
}

class _SelectLocationState extends ConsumerState<SelectLocation> {
  final MapController mapController = MapController();
  LatLng? currentPosition;
  StreamController<LocationMarkerPosition> locationMarkerPosStream =
      StreamController();
  List<List<LatLng>> nigerianMapBounds = [];
  LatLngBounds? nigeriaBounds;

  List<List<LatLng>> extractCoordinates(Map<String, dynamic> geojsonData) {
    // Get the coordinates from the MultiPolygon
    final coordinates =
        geojsonData['features'][0]['geometry']['coordinates'] as List;

    // Transform the nested lists into List<List<LatLng>>
    List<List<LatLng>> polygons = coordinates.map<List<LatLng>>((polygon) {
      // Get the first ring of coordinates for each polygon
      final ring = polygon[0] as List;

      // Convert each coordinate pair to LatLng
      return ring.map<LatLng>((coord) {
        // coord is a list with [longitude, latitude]
        return LatLng(
            coord[1], coord[0]); // Swap to latitude, longitude for LatLng
      }).toList();
    }).toList();
    log(polygons.toString());
    return polygons;
  }

  @override
  void initState() {
    super.initState();
    nigerianMapBounds = extractCoordinates(NigeriaBoundaries.coords);
    nigeriaBounds = LatLngBounds.fromPoints(
      nigerianMapBounds.map((e) => e).expand((e) => e).toList(),
    );
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
                      onPositionChanged: (camera, _) {
                        log(camera.center.toString());

                        locationMarkerPosStream.sink.add(
                          LocationMarkerPosition(
                            latitude: camera.center.latitude,
                            longitude: camera.center.longitude,
                            accuracy: 1,
                          ),
                        );
                      },
                    ),
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
                  Positioned(
                    bottom: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      child: Text(
                        "Move to select location",
                        style: kTextStyle(14),
                      ),
                    ),
                  )
                ],
              );
            },
            error: (e, _) {
              return const Center(
                child: Text("An Error occured"),
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
          Positioned(
            top: 70,
            left: 20,
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.7),
              ),
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                color: Colors.black,
              ),
              iconSize: 28,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
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
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedLocationUpdate02,
              color: AppColors.brown,
              size: 30,
            )),
      ),
    );
  }
}

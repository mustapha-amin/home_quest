import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geojson/geojson.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<List<LatLng>> parseNigeriaBorder(String geojsonData) async {
  final geojson = GeoJson();
  List<LatLng> borderPoints = [];

  await geojson.parse(geojsonData, verbose: false);

  for (var feature in geojson.features) {
    if (feature.geometry is GeoJsonPolygon) {
      final polygon = feature.geometry as GeoJsonPolygon;
      for (var geoSerie in polygon.geoSeries) {
        for (var point in geoSerie.geoPoints) {
          borderPoints.add(LatLng(point.latitude, point.longitude));
        }
      }
    }
  }

  geojson.dispose();
  return borderPoints;
}

Future<List<LatLng>> loadNigeriaBorder() async {
  final geojsonData = await rootBundle.loadString('assets/nigeria.geojson');
  return await compute(parseNigeriaBorder, geojsonData);
}
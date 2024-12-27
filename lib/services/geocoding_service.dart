import 'dart:convert';
import 'dart:developer';

import 'package:home_quest/models/geolocation.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class GeocodingService {
  static Future<GeoLocation?> reverseCoding(LatLng latlng) async {
    try {
      http.Response response = await http.get(Uri.parse(
          "https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${latlng.latitude}&lon=${latlng.longitude}"));
      GeoLocation geoLocation =
          GeoLocation.fromJson(json.decode(response.body));
      return geoLocation;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<GeoLocation?> forwardCoding(String? query) async {
    try {
      http.Response response = await http.get(Uri.parse(
          "https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1"));
      GeoLocation geoLocation =
          GeoLocation.fromJson(json.decode(response.body)[0]);
      return geoLocation;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

// {
//   "place_id": 37572448,
//   "licence": "Data © OpenStreetMap contributors, ODbL 1.0. http://osm.org/copyright",
//   "osm_type": "way",
//   "osm_id": 560121528,
//   "lat": "11.923367489096368",
//   "lon": "8.588584263272713",
//   "category": "highway",
//   "type": "residential",
//   "place_rank": 26,
//   "importance": 0.0533783344777599,
//   "addresstype": "road",
//   "name": "",
//   "display_name": "Kureken Sani, Kumbotso, Kano State, 700233, Nigeria",
//   "address": {
//     "city": "Kureken Sani",
//     "county": "Kumbotso",
//     "state": "Kano State",
//     "ISO3166-2-lvl4": "NG-KN",
//     "postcode": "700233",
//     "country": "Nigeria",
//     "country_code": "ng"
//   },
//   "boundingbox": [
//     "11.9233201",
//     "11.9244020",
//     "8.5838909",
//     "8.5886217"
//   ]
// }

// [
//   {
//     "place_id": 36616448,
//     "licence": "Data © OpenStreetMap contributors, ODbL 1.0. http://osm.org/copyright",
//     "osm_type": "relation",
//     "osm_id": 3710344,
//     "lat": "11.315691999999999",
//     "lon": "8.523903856610533",
//     "class": "boundary",
//     "type": "administrative",
//     "place_rank": 12,
//     "importance": 0.313419032962603,
//     "addresstype": "county",
//     "name": "Tudun Wada",
//     "display_name": "Tudun Wada, Kano State, Nigeria",
//     "address": {
//       "county": "Tudun Wada",
//       "state": "Kano State",
//       "ISO3166-2-lvl4": "NG-KN",
//       "country": "Nigeria",
//       "country_code": "ng"
//     },
//     "boundingbox": [
//       "11.1582092",
//       "11.4713000",
//       "8.2547080",
//       "8.7948947"
//     ]
//   },
// ]
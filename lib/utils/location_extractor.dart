import 'dart:convert';

import 'package:latlong2/latlong.dart';

class LocationExtractor {
  static LatLng? extract(dynamic data) {
    try {
      return data != null
          ? LatLng(data["coordinates"][0], data["coordinates"][1])
          : null;
    } catch (e) {
      return null;
    }
  }

  static LatLng? extractProductLocation(dynamic data) {
    if (data == null) {
      return null;
    }
    try {
      var s = json.decode(data);
      return LatLng(s["features"][0]["geometry"]["coordinates"][1],
          s["features"][0]["geometry"]["coordinates"][0]);
    } catch (e) {
      return null;
    }
  }
}

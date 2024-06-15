import 'package:latlong2/latlong.dart';

class LocationExtractor {
  static LatLng? extract(dynamic data) {
    try{
      return data != null
          ? LatLng(data["coordinates"][0], data["coordinates"][1])
          : null;
    }catch(e){
      return null;
    }

  }
}

import 'dart:convert';

class AddProductInfoReq {
  String? username;
  String? password;
  String? nationalId;
  String? imageApp;
  String? geolocation;
  double? lon;
  double? lat;

  AddProductInfoReq(
      {this.username,
      this.password,
      this.nationalId,
      this.imageApp,
      this.geolocation,
      this.lon,
      this.lat});

  factory AddProductInfoReq.fromJson(Map<String, dynamic> json) {
    return AddProductInfoReq(
      username: json['username'],
      password: json['password'],
      nationalId: json['national_id'],
      imageApp: json['image_app'],
      geolocation: json['geolocation'],
      lat: json["lat"],
      lon: json["lon"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'national_id': nationalId,
      'lat': lat,
      'lon': lon,
      'image_app': imageApp,
      'geolocation':
          "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{},\"geometry\":{\"type\":\"Point\",\"coordinates\":[${lon},${lat}]}}]}",
    };
  }

  /// Optional helper if geolocation is a JSON string
  Map<String, dynamic>? get geoLocationAsJson =>
      geolocation != null ? jsonDecode(geolocation!) : null;
}

import 'dart:convert';

import 'LivestockCheck.dart';

class AddDamInitialVisitRequest {
  String username;
  String password;

  String? nationalId;
  String? detail;

  String? jayType;
  String? tahjayType;
  int? masahat;
  String? hozche;
  String? tahvie;
  String? kafJay;
  String? abkhorStatus;
  String? nhdWarehouse;
  String? astar;
  String? vazeiat;
  String? waterQuality;
  String? waterSource;
  String? sayeban;
  String? sampash;
  String? martaStatus;

  String? bazdidImg;
  String? jaygahImg;
  String? damdarImg;
  String? damyarImg;

  String? geolocation;
  double? lat;
  double? lon;

  List<LivestockCheck> livestockCheck;

  AddDamInitialVisitRequest({
    required this.username,
    required this.password,
    this.nationalId,
    this.detail,
    this.jayType,
    this.tahjayType,
    this.masahat,
    this.hozche,
    this.tahvie,
    this.kafJay,
    this.abkhorStatus,
    this.nhdWarehouse,
    this.astar,
    this.vazeiat,
    this.waterQuality,
    this.waterSource,
    this.sayeban,
    this.sampash,
    this.martaStatus,
    this.bazdidImg,
    this.jaygahImg,
    this.damdarImg,
    this.damyarImg,
    this.geolocation,
    this.lat,
    this.lon,
    this.livestockCheck = const [],
  });

  //  data['geolocation'] =
  //         "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{},\"geometry\":{\"type\":\"Point\",\"coordinates\":[${lon},${lat}]}}]}";

  factory AddDamInitialVisitRequest.fromJson(Map<String, dynamic> json) {
    return AddDamInitialVisitRequest(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      nationalId: json['national_id'],
      detail: json['detail'],
      jayType: json['jay_type'],
      tahjayType: json['tahjay_type'],
      masahat: json['masahat'] as int?,
      hozche: json['hozche'],
      tahvie: json['tahvie'],
      kafJay: json['kaf_jay'],
      abkhorStatus: json['abkhor_status'],
      nhdWarehouse: json['nhd_warehouse'],
      astar: json['astar'],
      vazeiat: json['vazeiat'],
      waterQuality: json['water_quality'],
      waterSource: json['water_source'],
      sayeban: json['sayeban'],
      sampash: json['sampash'],
      martaStatus: json['marta_status'],
      bazdidImg: json['bazdid_img'],
      jaygahImg: json['jaygah_img'],
      damdarImg: json['damdar_img'],
      damyarImg: json['damyar_img'],
      lat: json['lat'],
      lon: json['lon'],
      geolocation: null,
      livestockCheck: (json['livestock_check'] as List?)
              ?.map((e) => LivestockCheck.fromJson(e))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    // auth
    data['username'] = username;
    data['password'] = password;

    // basic info
    if (nationalId != null) data['national_id'] = nationalId;
    if (detail != null) data['detail'] = detail;

    // place info
    if (jayType != null) data['jay_type'] = jayType;
    if (tahjayType != null) data['tahjay_type'] = tahjayType;
    if (masahat != null) data['masahat'] = masahat;
    if (hozche != null) data['hozche'] = hozche;
    if (tahvie != null) data['tahvie'] = tahvie;
    if (kafJay != null) data['kaf_jay'] = kafJay;
    if (abkhorStatus != null) data['abkhor_status'] = abkhorStatus;
    if (nhdWarehouse != null) data['nhd_warehouse'] = nhdWarehouse;
    if (astar != null) data['astar'] = astar;
    if (vazeiat != null) data['vazeiat'] = vazeiat;
    if (waterQuality != null) data['water_quality'] = waterQuality;
    if (waterSource != null) data['water_source'] = waterSource;
    if (sayeban != null) data['sayeban'] = sayeban;
    if (sampash != null) data['sampash'] = sampash;
    if (martaStatus != null) data['marta_status'] = martaStatus;
    if (lon != null) data['lon'] = lon;
    if (lat != null) data['lat'] = lat;
    // images
    if (bazdidImg != null) data['bazdid_img'] = bazdidImg;
    if (jaygahImg != null) data['jaygah_img'] = jaygahImg;
    if (damdarImg != null) data['damdar_img'] = damdarImg;
    if (damyarImg != null) data['damyar_img'] = damyarImg;

    // geolocation (GeoJSON string)
    if (lat != null && lon != null) {
      data['geolocation'] = jsonEncode({
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "properties": {},
            "geometry": {
              "type": "Point",
              "coordinates": [lon, lat]
            }
          }
        ]
      });
    }

    // livestock list
    if (livestockCheck.isNotEmpty) {
      data['livestock_check'] = livestockCheck.map((e) => e.toJson()).toList();
    }

    return data;
  }
}

import 'package:latlong2/latlong.dart';

import '../utils/location_extractor.dart';

class InitVisitInfoModel {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  int? docstatus;
  int? idx;
  String? nationalId;
  String? fullName;
  String? province;
  String? city;
  String? address;
  String? vDate;
  String? tarh;
  String? mobile;
  int? dam;
  String? noeDam;
  String? malekiyat;
  String? rahbar;
  String? department;
  String? vaziat;
  String? noeJaygah;
  String? qualityWater;
  String? taminWater;
  String? ajorMadani;
  String? sangNamak;
  String? adavat;
  String? kafJaygah;
  String? image1;
  String? status;
  int? sayeban;
  int? adamHesar;
  int? astarkeshi;
  int? mahalNegahdari;
  int? adamAbkhor;
  int? adamNoor;
  int? adamTahvie;
  String? sayer;
  String? eghdamat;
  LatLng? geolocation;
  String? doctype;

  InitVisitInfoModel(
      {required this.name,
      required this.owner,
      required this.creation,
      required this.modified,
      required this.modifiedBy,
      required this.docstatus,
      required this.idx,
      required this.nationalId,
      required this.fullName,
      required this.province,
      required this.city,
      required this.address,
      required this.vDate,
      required this.tarh,
      required this.mobile,
      required this.dam,
      required this.noeDam,
      required this.malekiyat,
      required this.rahbar,
      required this.department,
      required this.vaziat,
      required this.noeJaygah,
      required this.qualityWater,
      required this.taminWater,
      required this.ajorMadani,
      required this.sangNamak,
      required this.adavat,
      required this.kafJaygah,
      required this.image1,
      required this.status,
      required this.sayeban,
      required this.adamHesar,
      required this.astarkeshi,
      required this.mahalNegahdari,
      required this.adamAbkhor,
      required this.adamNoor,
      required this.adamTahvie,
      required this.sayer,
      required this.eghdamat,
      required this.geolocation,
      required this.doctype});

  InitVisitInfoModel.fromJson(Map<String?, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    nationalId = json['national_id'];
    fullName = json['full_name'];
    province = json['province'];
    city = json['city'];
    address = json['address'];
    vDate = json['v_date'];
    tarh = json['tarh'];
    mobile = json['mobile'];
    dam = json['dam'];
    noeDam = json['noe_dam'];
    malekiyat = json['malekiyat'];
    rahbar = json['rahbar'];
    department = json['department'];
    vaziat = json['vaziat'];
    noeJaygah = json['noe_jaygah'];
    qualityWater = json['quality_water'];
    taminWater = json['tamin_water'];
    ajorMadani = json['ajor_madani'];
    sangNamak = json['sang_namak'];
    adavat = json['adavat'];
    kafJaygah = json['kaf_jaygah'];
    image1 = json['image1'];
    status = json['status'];
    sayeban = json['sayeban'];
    adamHesar = json['adam_hesar'];
    astarkeshi = json['astarkeshi'];
    mahalNegahdari = json['mahal_negahdari'];
    adamAbkhor = json['adam_abkhor'];
    adamNoor = json['adam_noor'];
    adamTahvie = json['adam_tahvie'];
    sayer = json['sayer'];
    eghdamat = json['eghdamat'];
    geolocation = LocationExtractor.extract(json['geolocation']);
    doctype = json['doctype'];
  }
}

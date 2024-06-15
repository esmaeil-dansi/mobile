import 'package:frappe_app/utils/location_extractor.dart';
import 'package:latlong2/latlong.dart';

class PeriodicVisitInfoModel {
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
  String? tamin;
  String? outbreak;
  String? stableCondition;
  String? manger;
  String? losses;
  String? bazdid;
  String? water;
  String? supplySituation;
  String? ventilation;
  String? vaziat;
  String? rahbar;
  String? department;
  LatLng? geolocationP;
  String? date;
  String? doctype;

  PeriodicVisitInfoModel(
      {this.name,
      this.owner,
      this.creation,
      this.modified,
      this.modifiedBy,
      this.docstatus,
      this.idx,
      this.nationalId,
      this.fullName,
      this.province,
      this.city,
      this.tamin,
      this.outbreak,
      this.stableCondition,
      this.manger,
      this.losses,
      this.bazdid,
      this.water,
      this.supplySituation,
      this.ventilation,
      this.vaziat,
      this.rahbar,
      this.department,
      this.geolocationP,
      this.date,
      this.doctype});

  PeriodicVisitInfoModel.fromJson(Map<String?, dynamic> json) {
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
    tamin = json['tamin'];
    outbreak = json['outbreak'];
    stableCondition = json['stable_condition'];
    manger = json['manger'];
    losses = json['losses'];
    bazdid = json['bazdid'];
    water = json['water'];
    supplySituation = json['supply_situation'];
    ventilation = json['ventilation'];
    vaziat = json['vaziat'];
    rahbar = json['rahbar'];
    department = json['department'];
    geolocationP = LocationExtractor.extract(json['geolocation_p']);
    date = json['date'];
    doctype = json['doctype'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['name'] = this.name;
    data['owner'] = this.owner;
    data['creation'] = this.creation;
    data['modified'] = this.modified;
    data['modified_by'] = this.modifiedBy;
    data['docstatus'] = this.docstatus;
    data['idx'] = this.idx;
    data['national_id'] = this.nationalId;
    data['full_name'] = this.fullName;
    data['province'] = this.province;
    data['city'] = this.city;
    data['tamin'] = this.tamin;
    data['outbreak'] = this.outbreak;
    data['stable_condition'] = this.stableCondition;
    data['manger'] = this.manger;
    data['losses'] = this.losses;
    data['bazdid'] = this.bazdid;
    data['water'] = this.water;
    data['supply_situation'] = this.supplySituation;
    data['ventilation'] = this.ventilation;
    data['vaziat'] = this.vaziat;
    data['rahbar'] = this.rahbar;
    data['department'] = this.department;
    data['geolocation_p'] = this.geolocationP;
    data['date'] = this.date;
    data['doctype'] = this.doctype;
    return data;
  }
}

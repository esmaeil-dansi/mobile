class AddPerVisitFormModel {
  int? docstatus;
  String? doctype;
  String? name;
  int? iIslocal;
  int? iUnsaved;
  String? owner;
  String? outbreak;
  String? stableCondition;
  String? manger;
  String? losses;
  String? bazdid;
  String? water;
  String? supplySituation;
  String? ventilation;
  String? vaziat;
  String? jaigahDam;
  String? fullName;
  String? province;
  String? city;
  String? rahbar;
  String? department;
  String? nationalId;
  double? lat;
  double? lon;
  String? date;
  String? nextDate;
  String? image;
  String? enheraf;
  String? description_p;
  String? description_l;

  AddPerVisitFormModel({
    this.docstatus,
    this.doctype,
    this.name,
    this.iIslocal,
    this.lat,
    this.lon,
    this.enheraf,
    this.description_l,
    this.description_p,
    this.iUnsaved,
    this.owner,
    this.outbreak,
    this.stableCondition,
    this.manger,
    this.losses,
    this.bazdid,
    this.water,
    this.image,
    this.supplySituation,
    this.ventilation,
    this.vaziat,
    this.jaigahDam,
    this.fullName,
    this.province,
    this.city,
    this.rahbar,
    this.department,
    this.nationalId,
    this.date,
    this.nextDate,
  });

  AddPerVisitFormModel.fromJson(Map<String, dynamic> json) {
    docstatus = json['docstatus'];
    doctype = json['doctype'];
    name = json['name'];
    iIslocal = json['__islocal'];
    iUnsaved = json['__unsaved'];
    owner = json['owner'];
    outbreak = json['outbreak'];
    stableCondition = json['stable_condition'];
    manger = json['manger'];
    losses = json['losses'];
    bazdid = json['bazdid'];
    water = json['water'];
    supplySituation = json['supply_situation'];
    ventilation = json['ventilation'];
    vaziat = json['vaziat'];
    jaigahDam = json['jaigah_dam'];
    fullName = json['full_name'];
    province = json['province'];
    city = json['city'];
    rahbar = json['rahbar'];
    department = json['department'];
    nationalId = json['national_id'];
    lat = json['lat'];
    lon = json['lon'];
    date = json['date'];
    nextDate = json['next_date'];
    image = json['image'];
    description_p = json['description_p'];
    description_l = json['description_l'];
    enheraf = json['enheraf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['docstatus'] = docstatus;
    data['doctype'] = doctype;
    data['name'] = name;
    data['__islocal'] = iIslocal;
    data['__unsaved'] = iUnsaved;
    data['owner'] = owner;
    data['outbreak'] = outbreak;
    data['stable_condition'] = stableCondition;
    data['manger'] = manger;
    data['losses'] = losses;
    data['bazdid'] = bazdid;
    data['water'] = water;
    data['supply_situation'] = supplySituation;
    data['ventilation'] = ventilation;
    data['vaziat'] = vaziat;
    data['jaigah_dam'] = jaigahDam;
    data['full_name'] = fullName;
    data['province'] = province;
    data['city'] = city;
    data['rahbar'] = rahbar;
    data['department'] = department;
    data['national_id'] = nationalId;
    data['lat'] = lat;
    data['lon'] = lon;
    data['date'] = date;
    data['image'] = image;
    data['description_l'] = description_l;
    data['description_p'] = description_p;
    data['enheraf'] = enheraf;
    data['next_date'] = nextDate;
    return data;
  }
}

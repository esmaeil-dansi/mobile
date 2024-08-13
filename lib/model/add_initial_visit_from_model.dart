class AddInitialVisitFormModel {
  int? docstatus;
  String? doctype;
  String? name;
  int? iIslocal;
  int? iUnsaved;
  String? owner;
  String? tarh;
  int? dam;
  String? noeDam;
  String? malekiyat;
  String? vaziat;
  String? noeJaygah;
  String? qualityWater;
  String? taminWater;
  String? ajorMadani;
  String? sangNamak;
  String? adavat;
  String? kafJaygah;
  String? status;
  int? sayeban;
  int? adamHesar;
  int? astarkeshi;
  int? mahalNegahdari;
  int? adamAbkhor;
  int? adamNoor;
  int? adamTahvie;
  String? nationalId;
  String? fullName;
  String? province;
  String? city;
  String? address;
  String? mobile;
  String? rahbar;
  String? department;
  String? image1;
  String? eghdamat;
  String? sayer;
  String? vDate;
  String? image2;
  String? image3;
  double? lat;
  double? lon;
  String? geolocation;

  AddInitialVisitFormModel(
      {this.docstatus = 0,
      this.doctype = "Initial Visit",
      this.name = "new-initial-visit-1",
      this.iIslocal = 1,
      this.iUnsaved = 1,
      this.owner,
      this.tarh,
      this.dam,
      this.noeDam,
      this.malekiyat,
      this.vaziat,
      this.noeJaygah,
      this.qualityWater,
      this.taminWater,
      this.ajorMadani,
      this.sangNamak,
      this.adavat,
      this.kafJaygah,
      this.status,
      this.sayeban,
      this.adamHesar,
      this.astarkeshi,
      this.mahalNegahdari,
      this.adamAbkhor,
      this.adamNoor,
      this.adamTahvie,
      this.nationalId,
      this.fullName,
      this.image2,
      this.image3,
      this.province,
      this.city,
      this.address,
      this.sayer,
      this.mobile,
      this.rahbar,
      this.department,
      this.image1,
      this.eghdamat,
      this.vDate,
      this.lat,
      this.geolocation,
      this.lon});

  AddInitialVisitFormModel.fromJson(Map<String, dynamic> json) {
    docstatus = json['docstatus'] ?? 0;
    doctype = json['doctype'] ?? "Initial Visit";
    name = json['name'] ?? "new-initial-visit-1";
    iIslocal = json['__islocal'] ?? 1;
    iUnsaved = json['__unsaved'] ?? 1;
    owner = json['owner'];
    tarh = json['tarh'];
    dam = json['dam'];
    noeDam = json['noe_dam'];
    malekiyat = json['malekiyat'];
    vaziat = json['vaziat'];
    noeJaygah = json['noe_jaygah'];
    qualityWater = json['quality_water'];
    taminWater = json['tamin_water'];
    ajorMadani = json['ajor_madani'];
    sangNamak = json['sang_namak'];
    adavat = json['adavat'];
    kafJaygah = json['kaf_jaygah'];
    status = json['status'];
    sayeban = json['sayeban'];
    adamHesar = json['adam_hesar'];
    astarkeshi = json['astarkeshi'];
    mahalNegahdari = json['mahal_negahdari'];
    adamAbkhor = json['adam_abkhor'];
    adamNoor = json['adam_noor'];
    adamTahvie = json['adam_tahvie'];
    nationalId = json['national_id'];
    fullName = json['full_name'];
    province = json['province'];
    city = json['city'];
    address = json['address'];
    mobile = json['mobile'];
    rahbar = json['rahbar'];
    department = json['department'];
    image1 = json['image1'];
    image2 = json['image2'];
    image3 = json['image3'];
    eghdamat = json['eghdamat'];
    vDate = json['v_date'];
    lon = json['lon'];
    lat = json['lat'];
    sayer = json['sayer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['docstatus'] = this.docstatus;
    data['doctype'] = this.doctype;
    data['name'] = this.name;
    data['__islocal'] = this.iIslocal;
    data['__unsaved'] = this.iUnsaved;
    data['owner'] = this.owner;
    data['tarh'] = this.tarh;
    data['dam'] = this.dam;
    data['noe_dam'] = this.noeDam;
    data['malekiyat'] = this.malekiyat;
    data['vaziat'] = this.vaziat;
    data['noe_jaygah'] = this.noeJaygah;
    data['quality_water'] = this.qualityWater;
    data['tamin_water'] = this.taminWater;
    data['ajor_madani'] = this.ajorMadani;
    data['sang_namak'] = this.sangNamak;
    data['adavat'] = this.adavat;
    data['kaf_jaygah'] = this.kafJaygah;
    data['status'] = this.status;
    data['sayeban'] = this.sayeban;
    data['adam_hesar'] = this.adamHesar;
    data['astarkeshi'] = this.astarkeshi;
    data['mahal_negahdari'] = this.mahalNegahdari;
    data['adam_abkhor'] = this.adamAbkhor;
    data['adam_noor'] = this.adamNoor;
    data['adam_tahvie'] = this.adamTahvie;
    data['national_id'] = this.nationalId;
    data['full_name'] = this.fullName;
    data['province'] = this.province;
    data['city'] = this.city;
    data['address'] = this.address;
    data['mobile'] = this.mobile;
    data['rahbar'] = this.rahbar;
    data['department'] = this.department;
    data['image1'] = this.image1;
    data['image2'] = this.image2;
    data['image3'] = this.image3;
    data['eghdamat'] = this.eghdamat;
    data['v_date'] = this.vDate;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['sayer'] = this.sayer;
    data['geolocation'] =
        "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{},\"geometry\":{\"type\":\"Point\",\"coordinates\":[${lon},${lat}]}}]}";
    return data;
  }
}
